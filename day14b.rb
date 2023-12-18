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

  def hash
    @lines.hash
  end

  def eql?(other)
    rows == other.rows
  end
end

def reverse_tilt_column(array)
  array.join.split('#', -1).map { _1.chars.sort.reverse.join }.join("#")
end

def tilt_column(array)
  array.join.split('#', -1).map { _1.chars.sort.join }.join("#")
end

def tilt_north(board)
  Board.new(board.columns.map { reverse_tilt_column(_1) }).transpose
end

def tilt_south(board)
  Board.new(board.columns.map { tilt_column(_1) }).transpose
end

def tilt_east(board)
  Board.new(board.rows.map { tilt_column(_1) })
end

def tilt_west(board)
  Board.new(board.rows.map { reverse_tilt_column(_1) })
end

def spin_cycle(board)
  tilt_east(tilt_south(tilt_west(tilt_north(board))))
end

def score(board)
  result = 0
  board.rows.each_with_index do |row, index|
    result += row.tally.fetch("O", 0) * (board.rows_count - index)
  end
  result
end

def spin_cycle_n(board, n)
  n.times { board = spin_cycle(board) }
  board
end

lines = File.read("day14.in").split("\n")
# lines = File.read("/tmp/z").split("\n")
original_board = Board.new(lines)
board = Board.new(lines)

seen = Set.new
seen_array = []

until seen.include?(board.to_s)
  seen << board.to_s
  seen_array << board.to_s
  board = spin_cycle(board)
end

init_segment = seen_array.index(board.to_s)
cycle_array = seen_array[init_segment..]

x = 1_000_000 - 2
puts score(spin_cycle_n(original_board, ((x - init_segment) % cycle_array.length) + init_segment))
