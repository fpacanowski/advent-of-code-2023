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

State = Data.define(:board, :beams) do
  def move
    new_beams = beams.flat_map do |beam|
      beam.forward(board.at(beam.lookahead))
    end
    with(beams: new_beams)
  end

  def dedup
    with(beams: beams.uniq)
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

lines = File.read("day16.in").split("\n")
# lines = File.read("/tmp/z").split("\n")
board = Board.new(lines)

state = State.new(board, [Beam.new(Position.new(0, -1), :right)])

seen_beams = Set.new

until state.beams.all? { seen_beams.include?(_1) } do
  state.beams.each { |beam| seen_beams << beam }
  state = state.dedup
  state = state.move
end

energized_positions = Set.new(seen_beams.map(&:position))
puts energized_positions.size - 1
