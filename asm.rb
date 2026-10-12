require_relative "isa"
require_relative "labels"
require "elftools"

DEFAULT_OUTPUT_FILENAME = "a.out"

begin

class Assembler
  def initialize(isa, input_filename, output_filename = nil)
    @instr_count = 0
    @program = []
    @input_filename = input_filename
    @labels = []
    @fixup_table = []
    @v_address = 0x40100

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

  def write_elf
    default_code_segment_no = 0
    default_template_path = "resource/empty_elf.out"
    elf = ELFTools::ELFFile.new(File.open(default_template_path))
    elf.header.e_machine = TOY_ISA::TARGET_MACHINE
    start_label = @labels.find{ |label| label.label_name == :start }
    if not start_label
      raise RuntimeError.new("No such label as start😭")
    end
    elf.header.e_entry = start_label.offset * 4 + @v_address

    segment = elf.segment_by_type(:pt_load)
    segment.header.p_vaddr = @v_address
    segment.header.p_filesz = @instr_count * 4
    segment.header.p_memsz = @instr_count * 4
    segment.header.p_align = 4

    elf.save(@output_filename)

    offset = segment.header.p_offset

    File.open(@output_filename, "r+") do |f|
      f.seek(offset)
      f.write(@program.pack("V*"))
    end
  end

  def write_instr(instr)
    @instr_count += 1
    @program.append(instr)
  end
end
asm = Assembler.new(TOY_ISA, ARGV[0], ARGV[1])
asm.assemble
asm.write_elf

rescue => e
  puts e.message
end
