require_relative "encoding.rb"

# =================================== HELPERS =================================

def GenReg1(reg)
  reg << 21;
end

def GenReg2(reg)
  reg << 16;
end

def GenReg3(reg)
  reg << 11;
end

def GenBits(bits, low_b, up_b)
  n = up_b - low_b + 1;
  mask = UINT_MAX_32 >> (32 - n);
  (bits & mask) << low_b;
end

def WriteInstr(instr)
  $pc_ += 4
  $program.append(instr)
end

# ==================================== ASM_GEN ================================

32.times do |num|
  define_method("X#{num}") { |*offset| [num, *offset] }
end



def ld(*args)
  case args.size
  when 2
    if REGISTERS.include? args[0] and
       args[1].kind_of? Array and
       args[1].size == 2 and
       REGISTERS.include? args[1][0] and
       args[1][1].kind_of? Integer
      WriteInstr(LD | GenReg1(args[1][0]) | GenReg2(args[0]) | GenBits(0b00, 14, 15) |
         GenBits(args[1][1], 0, 13))
    else
      raise ArgumentError.new("Ld incorrect, go ботать toy-isa😭")
    end
  when 3
    if REGISTERS.include?(args[0]) and
       args[1].kind_of?(Array) and
       args[1].size == 1 and
       REGISTERS.include?(args[1][0]) and
       args[2].kind_of?(Integer)
      WriteInstr(LD_POST | GenReg1(args[1][0]) | GenReg2(args[0]) |
           GenBits(0b10, 14, 15) | GenBits(args[2], 0, 13))
    else
      raise ArgumentError.new("Ld incorrect, go ботать toy-isa😭")
    end
  else
    raise ArgumentError.new("Ld incorrect, go ботать toy-isa😭")
  end
end

def add(rd, rs, rt)
  WriteInstr(ADD | GenReg1(rs) | GenReg2(rt) | GenReg3(rd) |
         GenBits(0b00000, 6, 10) | GenBits(0b011000, 0, 5))
end

def beq(rs, rt, offset)
  WriteInstr(BEQ | GenReg1(rs) | GenReg2(rt) | GenBits(offset, 0, 15))
end

def li(rt, imm)
  WriteInstr(LI | GenBits(0b00000, 21, 25) | GenReg2(rt) | GenBits(imm, 0, 15))
end

def st(*args)
  if args.size == 2 and
    REGISTERS.include? args[0] and
    args[1].kind_of? Array and
    args[1].size == 2 and
    REGISTERS.include? args[1][0] and
    args[1][1].kind_of? Integer
      WriteInstr(ST | GenReg1(args[1][0]) | GenReg2(args[0]) | GenBits(0b00, 14, 15) |
       GenBits(args[1][1], 0, 13))
  else
    raise ArgumentError.new("Ld incorrect, go ботать toy-isa😭")
  end
end

def stp(*args)
  if args.size == 3 and
    REGISTERS.include? args[0] and
    REGISTERS.include? args[1] and
    args[2].kind_of? Array and
    args[2].size == 2 and
    REGISTERS.include?(args[2][0]) and
    args[2][1].kind_of?(Integer)
      WriteInstr(STP | GenReg1(args[2][0]) | GenReg2(args[0]) | GenReg3(args[1]) |
       GenBits(args[2][1], 0, 10))
  else
    raise ArgumentError.new("Stp incorrect, go ботать toy-isa😭")
  end
end

def addi(rt, rs, imm)
  WriteInstr(ADDI | GenReg1(rs) | GenReg2(rt) | GenBits(imm, 0, 15))
end

def j(instr_index)
  WriteInstr(J | GenBits(instr_index, 0, 25))
end

def nor(rd, rs, rt)
  WriteInstr(NOR | GenReg1(rs) | GenReg2(rt) | GenReg3(rd) |
       GenBits(0b101001, 0, 5))
end

def ssat(rd, rs, imm)
  WriteInstr(SSAT | GenReg1(rd) | GenReg2(rs) | GenBits(imm, 11, 15) | GenBits(0, 0, 10))
end

def rbit(rd, rs)
  WriteInstr(RBIT | GenReg1(rd) | GenReg2(rs) | GenBits(0, 6, 15) | GenBits(0b111110, 0, 5))
end

def syscall()
  WriteInstr(SYSCALL | GenBits(0b010000, 0, 5))
end

def bext(rd, rs1, rs2)
  WriteInstr(BEXT | GenReg1(rd) | GenReg2(rs1) | GenReg3(rs2) | GenBits(0, 6, 10))
       GenBits(0b100110, 0, 5)
end

def usat(rd, rs, imm)
  WriteInstr(USAT | GenReg1(rd) | GenReg2(rs) | GenBits(imm, 11, 15) | GenBits(0, 0, 10))
end
