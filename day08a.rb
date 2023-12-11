def parse(lines)
  instructions = lines.shift
  lines.shift
  graph = {}
  lines.each do |line|
    _, node, left, right = line.match(/(\w+) = \((\w+), (\w+)\)/).to_a
    graph[node] = [left, right]
  end
  [instructions, graph]
end

def move(graph, node, direction)
  if direction == "L"
    return graph.fetch(node)[0]
  elsif direction == "R"
    return graph.fetch(node)[1]
  else
    raise "this shouldnt happen"
  end
end

def solve(graph, instructions)
  i = 0
  node = "AAA"
  while node != "ZZZ"
    node = move(graph, node, instructions[i % instructions.size])
    i += 1
  end
  i
end

lines = File.read("day08.in").split("\n")
instructions, graph = parse(lines)

puts solve(graph, instructions)
