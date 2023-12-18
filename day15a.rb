def hash_algorithm(str)
  result = 0
  str.chars.each do |c|
    result = ((result + c.ord)) * 17 % 256
  end
  result
end

sequence = File.read("day15.in").strip.split(",")

puts sequence.map { hash_algorithm(_1) }.sum
