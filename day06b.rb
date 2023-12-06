Race = Data.define(:time_limit, :record)

def parse(lines)
	time = lines[0].split(':')[1].split.join.to_i
	distance = lines[1].split(':')[1].split.join.to_i
	Race.new(time, distance)
end

lines = File.read("day06.in").split("\n")
puzzle = parse(lines)

a, b, c = [-1, puzzle.time_limit, -puzzle.record]
delta = b**2 - 4*a*c

x1 = (-b + Math.sqrt(delta)) / (2*a)
x2 = (-b - Math.sqrt(delta)) / (2*a)

puts x2.floor - x1.ceil + 1