class Candidate
  class << self
    def keys
      %w(sanders clinton omalley)
    end

    def name(key)
      list.find { |c| c[:key] == key }[:name]
    end

    def list
      [
        {
          key: 'sanders',
          name: 'Bernie Sanders'
        },
        {
          key: 'clinton',
          name: 'Hillary Clinton'
        },
        {
          key: 'omalley',
          name: 'Martin O\'Malley'
        }
      ]
    end
  end
end
