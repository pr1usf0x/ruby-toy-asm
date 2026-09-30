class Label
  attr_reader :label_name, :offset
  def initialize(label_name, offset)
    @label_name = label_name
    @offset = offset
  end
end

class Fixup
  attr_reader :label_name, :block, :instr_count
  def initialize(label_name, block, instr_count)
    @label_name = label_name
    @block = block
    @instr_count = instr_count
  end
end