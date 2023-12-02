def parse(line)
	idx, spec = line.split(": ")
	idx = idx.split.last.to_i
	spec = spec.split(";").map { |s| s.split(", ").map { |x| x.split.reverse}.to_h.transform_values(&:to_i)}
	[idx, spec]
end

def solve(spec)
	min_cubes = {"red" => 0, "green" => 0, "blue" => 0}
	spec.each do |s|
	  r = s.fetch("red", 0)
		g = s.fetch("green", 0)
		b = s.fetch("blue", 0)
		min_cubes["red"] = [min_cubes["red"], r].max
		min_cubes["green"] = [min_cubes["green"], g].max
		min_cubes["blue"] = [min_cubes["blue"], b].max
	end
	min_cubes["red"]*min_cubes["green"]*min_cubes["blue"]
end

lines = File.read("day02.in").split("\n")
result = 0
lines.each do |line|
	idx, spec = parse(line)
	result += solve(spec)
end
puts result
