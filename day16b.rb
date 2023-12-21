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

Beam = Data.define(:position, :direction) do
  def forward(tile)
    new_position = position.move(direction)
    return [with(position: new_position)] if tile == "."
    return [] if tile == "#"

    new_directions = case [direction, tile]
      # RIGHT
      when [:right, "/"]
        [:up]
      when [:right, "\\"]
        [:down]
      when [:right, "-"]
        [:right]
      when [:right, "|"]
        [:up, :down]
      # LEFT
      when [:left, "/"]
        [:down]
      when [:left, "\\"]
        [:up]
      when [:left, "-"]
        [:left]
      when [:left, "|"]
        [:up, :down]
      # DOWN
      when [:down, "/"]
        [:left]
      when [:down, "\\"]
        [:right]
      when [:down, "-"]
        [:left, :right]
      when [:down, "|"]
        [:down]
      # UP
      when [:up, "/"]
        [:right]
      when [:up, "\\"]
        [:left]
      when [:up, "-"]
        [:left, :right]
      when [:up, "|"]
        [:up]
      else
        raise "this shouldn't happen"
    end
    new_directions.map { |d| Beam.new(new_position, d) }
  end

  def lookahead
    position.move(direction)
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
    return "#" unless 0 <= r && r < rows_count
    return "#" unless 0 <= c && c < columns_count
    @lines[r][c]
  end
end

def bfs(board, initial_vertex)
  queue = [initial_vertex]
  seen = Set.new
  until queue.empty?
    u = queue.shift
    seen << u
    neighbors = u.forward(board.at(u.lookahead))
    neighbors.each do |v|
      next if seen.include?(v)
      queue << v
    end
  end
  seen
end

lines = File.read("day16.in").split("\n")
board = Board.new(lines)

initial_states = []
initial_states += (0...board.rows_count).map { Beam.new(Position.new(_1, -1), :right) }
initial_states += (0...board.rows_count).map { Beam.new(Position.new(_1, board.columns_count), :left) }
initial_states += (0...board.columns_count).map { Beam.new(Position.new(-1, _1), :down) }
initial_states += (0...board.columns_count).map { Beam.new(Position.new(_1, board.rows_count), :up) }

result = 0
initial_states.each do |state|
  seen = bfs(board, state)
  energized_positions = Set.new(seen.map(&:position))
  result = [result, energized_positions.size - 1].max
end

puts result
