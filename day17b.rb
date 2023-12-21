require 'rbtree'

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

  def <=>(other)
    deconstruct <=> other.deconstruct
  end
end

Vertex = Data.define(:position, :direction, :stride) do
  def move(steps)
    new_position = position
    steps.times { new_position = new_position.move(direction) }
    with(position: new_position)
  end

  def <=>(other)
    deconstruct <=> other.deconstruct
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
  def initialize
    @rbtree = RBTree.new
  end

  def add(item, priority)
    @rbtree[[priority, item]] = :placeholder
  end

  def decrease_priority(item, old_priority, new_priority)
    @rbtree.delete([old_priority, item])
    add(item, new_priority)
  end

  def extract_min
    @rbtree.shift[0].reverse
  end

  def empty?
    @rbtree.empty?
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
  return false if v.stride > 10
  0 <= v.position.row && v.position.row < board.rows_count &&
  0 <= v.position.column && v.position.column < board.columns_count
end

def neighbors(board, v)
  result = []
  dist = 0
  if v.stride >= 4
    next_direction(v.direction).each do |new_direction|
      next_position = v.position.move(new_direction)
      new_v = v.with(position: next_position, direction: new_direction, stride: 1)
      result << [new_v, board.at(new_v.position)] if legal?(board, new_v)
    end
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
        old_distance = min_distances.fetch(v)
        min_distances[v] = alt
        queue.decrease_priority(v, old_distance, alt)
      end
    end
  end
  min_distances
end

lines = File.read("day17.in").split("\n")
board = Board.new(lines)

dest = Position.new(board.rows_count - 1, board.columns_count - 1)
min_distances = dijkstra(board)

keys = min_distances.keys.filter { _1.position == dest }
puts min_distances.fetch_values(*keys).min
