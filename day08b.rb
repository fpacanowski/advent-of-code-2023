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

def move_by(graph, instructions, start_node, steps)
  node = start_node
  steps.times do |i|
    node = move(graph, node, instructions[i % instructions.size])
  end 
  node
end

def find_cycle(graph, instructions, start_node)
  i = 0
  seen = Set.new
  seen_list = []
  node = [start_node, 0]
  cycle_start = nil
  loop do
    seen << node
    seen_list << node
    node = [move(graph, node[0], instructions[i % instructions.size]), (i + 1) % instructions.size]
    i += 1
    # puts [node, i % instructions.size].inspect
    if seen.include?(node)
      cycle_start = seen_list.index(node)
      break
    end
  end 
  [seen_list, cycle_start]
end

lines = File.read("day08.in").split("\n")
instructions, graph = parse(lines)

lengths = []
starting_nodes = graph.keys.filter { _1.end_with?("A") }
starting_nodes.each do |node|
  cycle, idx = find_cycle(graph, instructions, node)
  final_node_idx = cycle.find_index { |node| node[0].end_with?("Z") }
  cycle_length = cycle.size - idx
  # puts [node, final_node_idx, cycle_length].inspect
  lengths << cycle_length
end

# The answer is LCM of the cycle lengths.

puts lengths.join(" ")
