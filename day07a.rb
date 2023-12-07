Card = Data.define(:card) do
  def <=>(other)
    cards = %w[A K Q J T 9 8 7 6 5 4 3 2].reverse
    cards.index(card) <=> cards.index(other.card)
  end
end

HandType = Data.define(:type) do
  def <=>(other)
    types = [:five, :four, :full_house, :three, :two_pair, :one_pair, :high].reverse
    types.index(type) <=> types.index(other.type)
  end
end

Hand = Data.define(:cards) do
  def <=>(other)
    [hand_type(self), cards] <=> [hand_type(other), other.cards]
  end

  def inspect
    cards.map(&:card).join
  end
end
Game = Data.define(:hand, :bid)

def parse(lines)
  lines.map do |line|
    hand, bid = line.split
    hand = Hand.new(hand.chars.map { Card.new(_1) })
    bid = bid.to_i
    Game.new(hand, bid)
  end
end

def hand_type(hand)
  counts = hand.cards.tally.values.sort.reverse
  type = case counts
  when [5] then :five
  when [4, 1] then :four
  when [3, 2] then :full_house
  when [3, 1, 1] then :three
  when [2, 2, 1] then :two_pair
  when [2, 1, 1, 1] then :one_pair
  when [1, 1, 1, 1, 1] then :high
  else raise 'this shouldnt happen'
  end
  HandType.new(type)
end

lines = File.read("day07.in").split("\n")
puzzle = parse(lines)

result = puzzle.sort_by(&:hand).each_with_index.map { |game, rank| game.bid * (rank + 1) }.sum

puts result
