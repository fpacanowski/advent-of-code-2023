Card = Data.define(:winning, :chosen)

def parse(lines)
  lines.map do |line|
    winning, chosen = line.split(':')[1].split('|')
    winning = winning.split.map(&:to_i)
    chosen = chosen.split.map(&:to_i)
    Card.new(winning, chosen)
  end
end

def solve(card)
  intersection = card.winning & card.chosen
  return 0 if intersection.empty?
  2**(intersection.size-1)
end

lines = File.read("day04.in").split("\n")
cards = parse(lines)
result = cards.map(&method(:solve)).sum
puts result
