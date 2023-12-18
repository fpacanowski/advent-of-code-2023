Configuration = Data.define(:damaged_segments, :operational_segments) do
  def to_representation
    raise "this shouldnt happen" unless operational_segments.size == damaged_segments.size + 1
    ([0] + damaged_segments).zip(operational_segments).map do |dmg, op|
      "#"*dmg + "."*op
    end.join
  end
end

Puzzle = Data.define(:representation, :damaged_segments)

def possible_segments(n, k)
  a = (0...n).to_a
  a.product(a).flat_map do |left, right|
    possible_non_empty_segments(n - left - right, k).map { [left] + _1 + [right]}
  end
end

def possible_non_empty_segments(n, k)
  return [] if k > n
  return [[n]] if k == 1

  (1..n).flat_map do |first|
    possible_non_empty_segments(n - first, k - 1).map do |rest|
      [first] + rest
    end
  end
end

def possible_configurations(puzzle)
  possible_segments(
    puzzle.representation.size - puzzle.damaged_segments.sum,
    puzzle.damaged_segments.size - 1
  ).map do |operational_segments|
    Configuration.new(puzzle.damaged_segments, operational_segments)
  end
end

def compatible?(template, representation)
  raise "this shouldnt happen" if template.size != representation.size

  template.chars.zip(representation.chars).all? { |t, r| t == "?" || t == r }
end

def parse(lines)
  lines.map do |line|
    parts = line.split(" ")
    representation = parts.shift
    segments = parts.join.split(",").map(&:to_i)
    Puzzle.new(representation, segments)
  end
end

lines = File.read("day12.in").split("\n")
puzzles = parse(lines)

puzzle = puzzles.first

result = 0
puzzles.each do |puzzle|
  result += possible_configurations(puzzle)
  .map(&:to_representation)
  .filter { compatible?(puzzle.representation, _1) }.size
end

puts result
