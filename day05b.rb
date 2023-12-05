MyRange = Data.define(:start, :end) do
  def move(delta)
    with(start: start + delta, end: self.end + delta)
  end
end

MapRange = Data.define(:destination_start, :source_start, :length) do
  def contains?(x)
    source_start <= x && x < source_start+length
  end

  def translate(x)
    return nil unless contains?(x)
    x + destination_start - source_start
  end

  def source_end
    source_start + length - 1
  end

  def delta
    destination_start - source_start
  end

  def to_range
    MyRange.new(source_start, source_start + length - 1)
  end
end

Map = Data.define(:ranges) do
  def translate(x)
    ranges.each do |range|
      return range.translate(x) if range.contains?(x)
    end
    return x
  end

  def translate_range(input_range)
    sorted_ranges = ranges.sort_by(&:source_start)
    i = input_range.start
    result = []
    while i <= input_range.end
      r = sorted_ranges.first
      while !(sorted_ranges.empty? || r.contains?(i) || r.source_start > i)
        sorted_ranges.shift
        r = sorted_ranges.first
      end

      if sorted_ranges.empty?
        result.push(MyRange.new(i, input_range.end))
        break
      end

      if r.source_start <= i
        result.push(MyRange.new(i, [r.source_end, input_range.end].min).move(r.delta))
        i = r.source_end + 1
        sorted_ranges.shift
        next
      end

      result.push(MyRange.new(i, r.source_start - 1))
      result.push(MyRange.new(r.source_start, [r.source_end, input_range.end].min).move(r.delta))
      i = r.source_end + 1
      sorted_ranges.shift
    end
    result
  end
end

Puzzle = Data.define(:seeds, :maps) do
  def translate(x)
    maps.reduce(x) { |x, map| map.translate(x) }
  end
end

def parse(lines)
  seeds = lines.shift.split(':')[1].split.map(&:to_i)
  seeds = seeds.each_slice(2).map { |a, b| MyRange.new(a, a + b - 1) }
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
  reachable_ranges = puzzle.maps.reduce(puzzle.seeds) { |x, map| x.map { map.translate_range(_1) }.flatten(1) }
  reachable_ranges.map(&:start).min
end

lines = File.read("day05.in").split("\n")
puzzle = parse(lines)
puts solve(puzzle)
