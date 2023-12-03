Position = Data.define(:row, :column)
Number = Data.define(:position, :value)

class Board
  def initialize(lines)
    @lines = lines
  end

  def at(row, column)
    return '.' if row < 0 || row >= @lines.size
    line = @lines[row]
    return '.' if column < 0 || column >= line.size
    line[column]
  end

  def row_count
    @lines.size
  end

  def column_count
    @lines.first.size
  end
end

def find_numbers(board)
  numbers = []
  board.row_count.times do |r|
    i = 0
    num = ""
    start_i = nil
    while i <= board.column_count
      c = board.at(r, i)
      if "0123456789".include?(c)
        num += c
        start_i ||= i
      else
        numbers.push(Number.new(Position.new(r, start_i), num)) unless num.empty?
        num = ""
        start_i = nil
      end
      i += 1
    end
  end
  numbers
end

def neighbors(number)
  row, column = number.position.deconstruct
  ((column - 1)..(column + number.value.size)).map do |c|
    [Position.new(row-1, c), Position.new(row+1, c)]
  end.flatten + [Position.new(row, column-1), Position.new(row, column+number.value.size)]
end

def symbol?(c)
  c != '.' && !"0123456789".include?(c)
end

def verify(board, number)
  neighbors(number).any? do |position|
    r, c = position.deconstruct
    symbol?(board.at(r, c))
  end
end

lines = File.read("day03.in").split("\n")
board = Board.new(lines)

numbers = find_numbers(board)
result = 0
numbers.each do |num|
  result += num.value.to_i if verify(board, num)
end
puts result
