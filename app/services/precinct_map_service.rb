class PrecinctMapService
  class << self
    def locate(county, name)
      maps.each do |map|
        return map[2] if map[0] == county && map[1].include?(name)
      end
      nil
    end

    private

    def maps
      @@maps ||= IO.readlines(Rails.root.join('lib', 'map.csv')).map { |line| line.strip.split(',') }
    end
  end
end
