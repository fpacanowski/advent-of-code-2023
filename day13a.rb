Position = Data.define(:row, :column)

class Board
  def initialize(lines)
    @lines = lines
  end

  def rows_count
    @lines.size
  end

  def columns_count
    @lines.first.size
  end

  def at(position)
    @lines[position.row][position.column]
  end

  def all_positions
    positions = []
    rows_count.times { |r| columns_count.times { |c| positions << Position.new(r, c) } }
    positions
  end

  def row(index)
    @lines[index].chars
  end

  def column(index)
    @lines.map { |line| line[index] }
  end

  def transpose
    Board.new(columns_count.times.map { |i| column(i).join })
  end
end

def is_reflection_line?(board, index)
  a = index
  b = index + 1
  while a >= 0 && b < board.rows_count
    return false if board.row(a) != board.row(b)
    a -= 1
    b += 1
  end
  return true
end

def solve(board)
  (0...board.rows_count - 1).filter { is_reflection_line?(board, _1) }
end

lines = File.read("day13.in").split("\n")
lines << ""

boards = []
board_lines = []
until lines.empty?
  line = lines.shift
  if line.empty?
    boards << Board.new(board_lines)
    board_lines = []
  else
    board_lines << line
  end
end

result = 0
boards.each do |board|
  a = solve(board).map { _1 + 1}
  b = solve(board.transpose).map { _1 + 1}
  result += 100 * a.sum
  result += b.sum
end

puts result
