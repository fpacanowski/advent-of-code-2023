def parse(line)
  digits = line.chars.filter { |c| "0123456789".include?(c) }
  "#{digits.first}#{digits.last}".to_i
end

lines = File.read("day01.in").split
puts lines.map(&method(:parse)).sum