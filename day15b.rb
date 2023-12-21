Lens = Data.define(:label, :focal_length)
RemoveInstruction = Data.define(:label)
SetInstruction = Data.define(:label, :focal_length)

class Box
  attr_reader :lenses

  def initialize
    @lenses = []
  end

  def execute(instruction)
    case instruction
    in RemoveInstruction(label)
      @lenses = @lenses.filter { _1.label != label }
    in SetInstruction(label, focal_length)
      index = @lenses.find_index { _1.label == label }
      if index.nil?
        @lenses << Lens.new(label, focal_length)
      else
        @lenses[index] = Lens.new(label, focal_length)
      end
    else
      raise "this shouldn't happen"
    end
  end
end

class Machine
  def initialize
    @boxes = []
    256.times { @boxes << Box.new }
  end

  def execute(instruction)
    box_index = hash_algorithm(instruction.label)
    @boxes[box_index].execute(instruction)
  end

  def focusing_power
    @boxes.each_with_index.map do |box, box_index|
      box_value = box.lenses.each_with_index.map do |lens, lens_index|
        (box_index + 1) * (lens_index + 1) * lens.focal_length 
      end
    end.flatten.sum
  end

end

def parse(sequence)
  sequence.map do |instruction|
    if instruction.end_with?("-")
      label = instruction[...instruction.size-1]
      RemoveInstruction.new(label)
    elsif instruction.include?("=")
      label, focal_length = instruction.split("=")
      focal_length = focal_length.to_i
      SetInstruction.new(label, focal_length)
    else
      raise "this shouldnt happen"
    end
  end
end

def hash_algorithm(str)
  result = 0
  str.chars.each do |c|
    result = ((result + c.ord)) * 17 % 256
  end
  result
end

sequence = File.read("day15.in").strip.split(",")

m = Machine.new
parse(sequence).each do |instruction|
  m.execute(instruction)
end

puts m.focusing_power
