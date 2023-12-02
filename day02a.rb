def parse(line)
  idx, spec = line.split(": ")
  idx = idx.split.last.to_i
  spec = spec.split(";").map { |s| s.split(", ").map { |x| x.split.reverse}.to_h.transform_values(&:to_i)}
  [idx, spec]
end

def possible?(spec)
  spec.fetch('red', 0) <= 12 && spec.fetch('green', 0) <= 13 && spec.fetch('blue',0) <= 14
end

lines = File.read("day02.in").split("\n")

result = 0
lines.each do |line|
  idx, spec = parse(line)
  result += idx if spec.all? { |s| possible?(s) }
end
puts result