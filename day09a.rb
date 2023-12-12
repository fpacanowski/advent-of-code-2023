def parse(lines)
  lines.map { _1.split.map(&:to_i) }
end

def solve(puzzle)
  numbers = puzzle.dup
  history = []
  history << numbers
  while numbers.any?{ _1 != 0}
    numbers = numbers.each_cons(2).map { |a, b| b-a }
    history << numbers
  end
  a = 0
  history.reverse[1..].each do |numbers|
    a = numbers.last + a
  end
  a
end

lines = File.read("day09.in").split("\n")
puzzles = parse(lines)

result = 0
puzzles.each do |puzzle|
  result += solve(puzzle)
end

puts result
