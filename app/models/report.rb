class Report < ActiveRecord::Base
  include AASM

  belongs_to :precinct
  belongs_to :user

  enum source: [:microsoft, :captain, :crowd, :manual]

  default_scope -> { order(created_at: :desc) }

  serialize :delegate_counts
  serialize :results_counts

  validates :precinct_id, :aasm_state, :total_attendees, presence: true

  aasm do
    state :start, initial: true
    state :viability
    state :apportionment
    state :coin_flip
    state :apportioned

    event :begin do
      transitions from: :start, to: :viability
    end

    event :viable do
      transitions from: :viability, to: :apportionment
    end

    event :apportion do
      transitions from: :apportionment, to: :apportioned
    end

    event :apportion_preflip do
      transitions from: :apportionment, to: :coin_flip
    end

    event :flip do
      transitions from: :coin_flip, to: :apportioned
    end
  end

  def candidate_count(key)
    (delegate_counts || {})[key.intern] || 0
  end

  def candidate_delegates(key)
    key = key.intern
    if (results_counts || {})[key]
      # If we have a Microsoft report, return it
      results_counts[key]
    else
      return 0 if total_attendees == 0
      calculated_delegates[key]
    end
  end

  def threshold
    multiplier =
      if precinct.total_delegates == 1
        0.50
      elsif precinct.total_delegates == 2
        0.25
      elsif precinct.total_delegates == 3
        1.0 / 6.0
      else
        0.15
      end
    (total_attendees.to_f * multiplier).ceil
  end

  def above_threshold?(key)
    candidate_count(key) >= threshold
  end

  def viable?(key)
    above_threshold?(key) || precinct.reports.captain.apportionment.exists?(user: user) && precinct.reports.captain.apportionment.find_by(user: user).above_threshold?(key)
  end

  def needs_flip?
    viable_counts = (delegate_counts || []).sort_by { |_, v| v }.select { |_, v| v > threshold }.reverse
    viable_counts = viable_counts.map do |c|
      del = c.last.to_f / total_attendees.to_f * precinct.total_delegates.to_f
      { key: c.first, decimal: del - del.to_i }
    end
    (0...viable_counts.length - 1).each do |i|
      return true if viable_counts[i][:decimal] == 0.5 && viable_counts[i + 1][:decimal] == 0.5
    end
    false
  end

  def calculated_delegates
    sorted_counts = (delegate_counts || []).sort_by { |_, v| v }.reverse.to_h

    sorted_delegate_counts = sorted_counts.map do |k, v|
      dc = v.to_f * precinct.total_delegates.to_f / total_attendees.to_f
      h = {}
      h[k] = dc
      h
    end
    sorted_delegate_counts = sorted_delegate_counts.inject(:merge)

    final_delegate_counts = sorted_delegate_counts.map do |k, v|
      next unless above_threshold?(k)
      h = {}
      h[k] = v.round
      h
    end
    final_delegate_counts = final_delegate_counts.compact.inject(:merge)
    return {} if final_delegate_counts.nil?

    # Determine if a flip adjustment is needed.
    point_fives = {}
    sorted_delegate_counts.to_a.each_with_index do |c, i|
      next if i + 1 == sorted_delegate_counts.to_a.size
      count = c.last
      nc = sorted_delegate_counts.to_a[i + 1]
      next_count = nc.last
      if count - count.to_i == 0.5 && next_count - next_count.to_i == 0.5
        point_fives[c.first] = c.last
        point_fives[nc.first] = nc.last
      end
    end
    # Perform any flip adjustments.
    point_fives.each { |five, _| final_delegate_counts[five] -= 1 unless flip_winner.try(:intern) == five }

    # Perform any adjustments based on minimum-1-delegate rule.
    adjust_keys = []
    adjust_keys = Candidate.keys.map { |key| key.intern if !above_threshold?(key) && viable?(key) }.compact if captain? || manual?
    if adjust_keys.any?
      final_delegate_counts[final_delegate_counts.keys.last] -= adjust_keys.count
      adjust_keys.each { |key| final_delegate_counts[key] = 1 }
    end

    # If not all delegates are distributed, give to the highest decimal.
    total_allocated = final_delegate_counts.map { |_, v| v }.reduce(:+)
    if total_allocated < precinct.total_delegates
      decimals = sorted_delegate_counts.map do |k, v|
        dec = v - v.to_i
        h = {}
        h[k] = dec
        h
      end
      decimals = decimals.inject(:merge).sort_by { |_, v| v }.reverse.to_h
      winner_decimals = decimals.select { |_k, v| v == decimals[decimals.keys.first] }
      final_delegate_counts[winner_decimals.keys.first] += 1 if winner_decimals.keys.count == 1 && final_delegate_counts[winner_decimals.keys.first]
    end

    final_delegate_counts
  end
end
