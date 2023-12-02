def parse(line)
  dict = {
    # "0" => 0,
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    # "zero" => 0,
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
  }
  digits = dict
    .map { |k, v| [[line.index(k), v], [line.rindex(k), v]] }
    .flatten(1)
    .filter { |x| x.compact.size == 2 }
    .sort_by(&:first)
    .map(&:last)
  "#{digits.first}#{digits.last}".to_i
end

lines = File.read("day01.in").split
puts lines.map(&method(:parse)).sum