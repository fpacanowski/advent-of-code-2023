Race = Data.define(:time_limit, :record)

def parse(lines)
	times = lines[0].split(':')[1].split.map(&:to_i)
	distances = lines[1].split(':')[1].split.map(&:to_i)
	times.zip(distances).map { |t, d| Race.new(t, d) }
end

def possible_strategies(race)
	(0..race.time_limit)
		.map { |t| t * (race.time_limit - t) }
		.filter { |t| t > race.record}
end

lines = File.read("day06.in").split("\n")
puzzle = parse(lines)

puts puzzle.map { |r| possible_strategies(r).size }.reduce(:*)
