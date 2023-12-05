Card = Data.define(:winning, :chosen)

def parse(lines)
  lines.map do |line|
    winning, chosen = line.split(':')[1].split('|')
    winning = winning.split.map(&:to_i)
    chosen = chosen.split.map(&:to_i)
    Card.new(winning, chosen)
  end
end

def score(card)
  intersection = card.winning & card.chosen
  intersection.size
end

lines = File.read("day04.in").split("\n")
cards = parse(lines)
counts = [1]*300

cards.each_with_index do |card, idx|
  s = score(card)
  ((idx+1)..(idx+s)).each { |i| counts[i] += counts[idx] }
end

puts counts[...(lines.size)].sum
