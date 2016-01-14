states = [
  { name: 'Iowa', code: 'IA', caucus_date: Date.parse('01-02-2016') },
  { name: 'Nevada', code: 'NV', caucus_date: Date.parse('20-02-2016') },
  { name: 'Colorado', code: 'CO', caucus_date: Date.parse('01-03-2016') },
  { name: 'Minnesota', code: 'MN', caucus_date: Date.parse('01-03-2016') },
  { name: 'Nebraska', code: 'NE', caucus_date: Date.parse('05-03-2016') },
  { name: 'Kansas', code: 'KS', caucus_date: Date.parse('05-03-2016') },
  { name: 'Maine', code: 'ME', caucus_date: Date.parse('06-03-2016') },
  { name: 'Idaho', code: 'ID', caucus_date: Date.parse('22-03-2016') },
  { name: 'Utah', code: 'UT', caucus_date: Date.parse('22-03-2016') },
  { name: 'Alaska', code: 'AK', caucus_date: Date.parse('26-03-2016') },
  { name: 'Hawaii', code: 'HI', caucus_date: Date.parse('26-03-2016') },
  { name: 'Washington', code: 'WA', caucus_date: Date.parse('26-03-2016') },
  { name: 'Wyoming', code: 'WY', caucus_date: Date.parse('09-04-2016') }
]

states.each do |state|
  State.create(name: state[:name], code: state[:code], caucus_date: state[:caucus_date]) unless State.exists?(name: state[:name], code: state[:code])
end

unless Rails.env.test?
  Dir.glob(Rails.root.join('db', 'data', '*.csv')).each do |file|
    File.open(file).each do |line|
      line = line.split(',')
      state = State.find_by_code(line[0])
      state.precincts.create(county: line[1], name: line[2], total_delegates: line[3].to_i) unless state.precincts.exists?(county: line[1], name: line[2])
    end
  end
end
