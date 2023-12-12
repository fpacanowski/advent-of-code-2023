Position = Data.define(:row, :column) do
  def north
    self.with(row: row - 1)
  end
  def south
    self.with(row: row + 1)
  end
  def west
    self.with(column: column - 1)
  end
  def east
    self.with(column: column + 1)
  end
end

DIRECTIONS = {
  "-" => [:west, :east],
  "7" => [:west, :south],
  "J" => [:west, :north],
  "|" => [:north, :south],
  "L" => [:north, :east],
  "F" => [:south, :east],
}

def parse(lines)
  lines.map { _1.split.map(&:to_i) }
end

class Board
  def initialize(lines)
    @lines = lines
  end

  def neighbors(position)
    result = []
    r, c = position.deconstruct
    if at(position) == 'S'
      result << position.west if "-LF".chars.include?(at(position.west))
      result << position.east if "-J7".chars.include?(at(position.east))
      result << position.north if "|7F".chars.include?(at(position.north))
      result << position.south if "|JL".chars.include?(at(position.south))
      return result
    end
  end

  def at(position)
    r, c = position.deconstruct
    return '#' unless 0 <= r && r < @lines.size
    line = @lines[r]
    return '#' unless 0 <= c && c < line.size
    line[c]
  end

  def start
    all_positions.each do |pos|
        return pos if at(pos) == 'S'
    end
    raise "This shouldnt happen"
  end

  def all_positions
    result = []
    @lines.size.times do |r|
      @lines.first.size.times do |c|
        result << Position.new(r, c)
      end
    end
    result
  end
end

def candidates(board, position)
  DIRECTIONS.fetch(board.at(position)).map do |direction|
    position.send(direction)
  end
end

def find_cycle(board)
  cycle = [board.start]
  prev_position = board.start
  position = board.neighbors(board.start).first
  
  while board.at(position) != 'S'
    cycle << position
    next_position = candidates(board, position).filter { _1 != prev_position }.first
  
    prev_position = position
    position = next_position
  end
  cycle
end

def to_right(a, b)
  {
    [0, 1] => :south,  
    [0, -1] => :north,
    [1, 0] => :west,
    [-1, 0] => :east,  
  }.fetch([b.row - a.row, b.column - a.column])
end

def find_area(board, cycle)
  cycle = cycle.dup
  cycle << cycle.first
  seen = Set.new
  cycle_set = Set.new(cycle)
  cycle.each_cons(2).each do |a, b|
    dir = to_right(a, b)
    p = b.send(dir)
    q = a.send(dir)

    queue = [p, q]
    while !queue.empty?
      v = queue.shift
      next if board.at(v) == '#'
      next if seen.include?(v)
      next if cycle_set.include?(v)

      seen << v
      queue << v.north
      queue << v.south
      queue << v.east
      queue << v.west
    end
  end
  seen
end

lines = File.read("day10.in").split("\n")
board = Board.new(lines)

cycle = find_cycle(board)

puts find_area(board, cycle).size
puts find_area(board, cycle.reverse).size
