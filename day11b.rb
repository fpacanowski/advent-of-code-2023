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
end

def find_stars(board)
  board.all_positions.filter { |p| board.at(p) == '#' }
end

def row_span(a, b)
  row1, row2 = [a.row, b.row].sort
  Set.new(((row1+1)..(row2-1)).to_a)
end

def column_span(a, b)
  col1, col2 = [a.column, b.column].sort
  Set.new(((col1+1)..(col2-1)).to_a)
end

def distance(empty_rows, empty_columns, a, b)
  base_distance = (a.row - b.row).abs + (a.column - b.column).abs
  base_distance +
    empty_rows.intersection(row_span(a, b)).size * 999_999 + 
    empty_columns.intersection(column_span(a, b)).size * 999_999
end

def solve(board)
  empty_rows = Set.new(
    board.rows_count.times.to_a.filter { |r| board.row(r).all? { _1 == "."} }
  )

  empty_columns = Set.new(
    board.columns_count.times.to_a.filter { |c| board.column(c).all? { _1 == "."} }
  )

  find_stars(board).combination(2).map do |a, b|
    distance(empty_rows, empty_columns, a, b)
  end.sum
end

lines = File.read("day11.in").split("\n")
board = Board.new(lines)

puts solve(board)
