require_relative "isa"
require_relative "labels"

DEFAULT_OUTPUT_FILENAME = "a.out".freeze

begin

class Assembler
  class Integer end

  def initialize(isa, input_filename, output_filename = nil)
    @instr_count = 0
    @program = []
    @input_filename = input_filename
    @labels = []
    @fixup_table = []

    extend isa

    @input_content = File.read(@input_filename)

    if not output_filename
      @output_filename = DEFAULT_OUTPUT_FILENAME
    else
      @output_filename = output_filename
    end
  end

  def label(name)
    @labels.append(Label.new(name, @instr_count))
  end

  def add_fixup(fixup)
    @fixup_table.append(fixup)
  end

  def assemble
    instance_eval(@input_content)
    @fixup_table.each do |fixup|
      target = @labels.find{ |label| label.label_name == fixup.label_name }
      if not target
        raise RuntimeError.new("No such label as #{fixup.label_name}😭")
      end
      fixup.block.call(@program, fixup.instr_count, target.offset)
    end
  end

  def write_file
    File.open(@output_filename, "wb")
    File.binwrite(@output_filename, @program.pack("V*"))
  end

  def write_instr(instr)
    @instr_count += 1
    @program.append(instr)
  end
end

asm = Assembler.new(TOY_ISA, ARGV[0], ARGV[1])
asm.assemble
asm.write_file

rescue => e
  puts e.message
end
