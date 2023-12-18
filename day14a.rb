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

  def row(index)
    @lines[index].chars
  end

  def column(index)
    @lines.map { |line| line[index] }
  end

  def rows
    rows_count.times.map { row(_1) }
  end

  def columns
    columns_count.times.map { column(_1) }
  end

  def transpose
    Board.new(columns_count.times.map { |i| column(i).join })
  end

  def to_s
    @lines.join("\n")
  end
end

def tilt_column(array)
  array.join.split('#', -1).map { _1.chars.sort.reverse.join }.join("#")
end

def tilt(board)
  Board.new(board.columns.map { tilt_column(_1) }).transpose
end

def score(board)
  result = 0
  board.rows.each_with_index do |row, index|
    result += row.tally.fetch("O", 0) * (board.rows_count - index)
  end
  result
end

lines = File.read("day14.in").split("\n")
board = Board.new(lines)

puts score(tilt(board))
