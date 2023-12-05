MapRange = Data.define(:destination_start, :source_start, :length) do
  def contains?(x)
    source_start <= x && x < source_start+length
  end

  def translate(x)
    return nil unless contains?(x)
    x + destination_start - source_start
  end
end

Map = Data.define(:ranges) do
  def translate(x)
    ranges.each do |range|
      return range.translate(x) if range.contains?(x)
    end
    return x
  end
end

Puzzle = Data.define(:seeds, :maps) do
  def translate(x)
    maps.reduce(x) { |x, map| map.translate(x) }
  end
end

def parse(lines)
  seeds = lines.shift.split(':')[1].split.map(&:to_i)
  lines.shift
  lines.push ""
  maps = []
  ranges = []
  lines.each do |line|
    next if line.match?(/[a-z]/)
    if line.empty?
      maps.push(Map.new(ranges))
      ranges = []
    else
      ranges.push(MapRange.new(*line.split.map(&:to_i)))
    end
  end
  Puzzle.new(seeds, maps)
end

def solve(puzzle)
  puzzle.seeds.map { |x| puzzle.translate(x) }.min
end

lines = File.read("day05.in").split("\n")
puzzle = parse(lines)
puts solve(puzzle)
