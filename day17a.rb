Position = Data.define(:row, :column) do
  def move(direction)
    case direction
    when :left
      with(column: column - 1)
    when :right
      with(column: column + 1)
    when :up
      with(row: row - 1)
    when :down
      with(row: row + 1)
    else
      raise "this shouldnt happen"
    end
  end
end

Vertex = Data.define(:position, :direction, :stride) do
  def move(steps)
    new_position = position
    steps.times { new_position = new_position.move(direction) }
    with(position: new_position)
  end
end

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
    r, c = position.deconstruct
    @lines[r][c].to_i
  end
end

class PriorityQueue
  attr_reader :queue

  def initialize
    @queue = []
  end

  def add(item, priority)
    @queue << [item, priority]
  end

  def decrease_priority(item, new_priority)
    @queue.find { _1.first == item }[1] = new_priority
  end

  def extract_min
    min = @queue.min_by(&:last)
    @queue.delete(min)
  end

  def empty?
    @queue.empty?
  end
end

def next_direction(direction)
  {
    left: [:up, :down],
    right: [:up, :down],
    down: [:left, :right],
    up: [:left, :right],
  }.fetch(direction)
end

def legal?(board, v)
  return false if v.stride > 3
  0 <= v.position.row && v.position.row < board.rows_count &&
  0 <= v.position.column && v.position.column < board.columns_count
end

def neighbors(board, v)
  result = []
  dist = 0
  next_direction(v.direction).each do |new_direction|
    next_position = v.position.move(new_direction)
    new_v = v.with(position: next_position, direction: new_direction, stride: 1)
    result << [new_v, board.at(new_v.position)] if legal?(board, new_v)
  end
  new_v = v.move(1).with(stride: v.stride + 1)
  result << [new_v, board.at(new_v.position)] if legal?(board, new_v)
  result
end

def dijkstra(board)
  origin = Position.new(0, 0)
  initial1 = Vertex.new(origin, :right, 1)
  initial2 = Vertex.new(origin, :down, 1)
  min_distances = {initial1 => 0, initial2 => 0}
  queue = PriorityQueue.new
  queue.add(initial1, 0)
  queue.add(initial2, 0)
  until queue.empty?
    u, _ = queue.extract_min
    neighbors(board, u).each do |v, dist|
      # require 'pry'; binding.pry
      alt = min_distances.fetch(u) + dist
      if !min_distances.include?(v)
        min_distances[v] = alt
        queue.add(v, alt)
      elsif alt < min_distances.fetch(v)
        min_distances[v] = alt
        queue.decrease_priority(v, alt)
      end
    end
  end
  min_distances
end

lines = File.read("day17.in").split("\n")
# lines = File.read("/tmp/z").split("\n")
board = Board.new(lines)

dest = Position.new(board.rows_count - 1, board.columns_count - 1)
min_distances = dijkstra(board)

keys = min_distances.keys.filter { _1.position == dest }
puts min_distances.fetch_values(*keys).min
