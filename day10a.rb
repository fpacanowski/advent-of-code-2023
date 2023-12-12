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
    return '.' unless 0 <= r && r < @lines.size
    line = @lines[r]
    return '.' unless 0 <= c && c < line.size
    line[c]
  end

  def start
    @lines.size.times do |r|
      @lines.first.size.times do |c|
        pos = Position.new(r, c)
        return pos if at(pos) == 'S'
      end
    end
    raise "This shouldnt happen"
  end
end

def candidates(board, position)
  DIRECTIONS.fetch(board.at(position)).map do |direction|
    position.send(direction)
  end
end

lines = File.read("day10.in").split("\n")
board = Board.new(lines)

cycle = []
prev_position = board.start
position = board.neighbors(board.start).first

while board.at(position) != 'S'
  cycle << position
  next_position = candidates(board, position).filter { _1 != prev_position }.first

  prev_position = position
  position = next_position
end

puts cycle.size/2+1
