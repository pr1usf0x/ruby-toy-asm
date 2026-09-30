module TOY_ISA

X0 = 0.freeze
X1 = 1.freeze
X2 = 2.freeze
X3 = 3.freeze
X4 = 4.freeze
X5 = 5.freeze
X6 = 6.freeze
X7 = 7.freeze
X8 = 8.freeze
X9 = 9.freeze
X10 = 10.freeze
X11 = 11.freeze
X12 = 12.freeze
X13 = 13.freeze
X14 = 14.freeze
X15 = 15.freeze
X16 = 16.freeze
X17 = 17.freeze
X18 = 18.freeze
X19 = 19.freeze
X20 = 20.freeze
X21 = 21.freeze
X22 = 22.freeze
X23 = 23.freeze
X24 = 24.freeze
X25 = 25.freeze
X26 = 26.freeze
X27 = 27.freeze
X28 = 28.freeze
X29 = 29.freeze
X30 = 30.freeze
X31 = 31.freeze
PC = 32.freeze

LD = (0b010111 << 26).freeze
ADD = (0b000000 << 26).freeze
BEQ = (0b001101 << 26).freeze
LI = (0b101011 << 26).freeze
ST = (0b101100 << 26).freeze
STP = (0b111111 << 26).freeze
ADDI = (0b001010 << 26).freeze
J = (0b110111 << 26).freeze
LD_POST = (0b000111 << 26).freeze
NOR = (0b000000 << 26).freeze
SSAT = (0b010100 << 26).freeze
RBIT = (0b000000 << 26).freeze
SYSCALL = (0b000000 << 26).freeze
BEXT = (0b000000 << 26).freeze
USAT = (0b110000 << 26).freeze

REGISTERS = [
  X0, X1, X2, X3, X4, X5, X6, X7,
  X8, X9, X10, X11, X12, X13, X14, X15,
  X16, X17, X18, X19, X20, X21, X22, X23,
  X24, X25, X26, X27, X28, X29, X30, X31
].freeze

UINT_MAX_32 = 0b11111111111111111111111111111111.freeze

PRINT_UNSIGNED = 1.freeze
SCAN_UNSIGNED = 0.freeze
ABORT = 61.freeze
EXIT = 60.freeze

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

# ==================================== ASM_GEN ================================

class ::Integer
  def call(reg)
    if not REGISTERS.include? reg
      raise ArgumentError.new("Imm(...) incorrect syntax😭")
    end
    [reg, self]
  end
end

def ld(*args)
  case args.size
  when 2
    if REGISTERS.include? args[0] and
       args[1].kind_of? Array and
       args[1].size == 2 and
       REGISTERS.include? args[1][0] and
       args[1][1].kind_of? ::Integer
      write_instr(LD | GenReg1(args[1][0]) | GenReg2(args[0]) | GenBits(0b00, 14, 15) |
         GenBits(args[1][1], 0, 13))
    else
      raise ArgumentError.new("Ld incorrect, go ботать toy-isa😭")
    end
  when 3
    if REGISTERS.include?(args[0]) and
       args[1].kind_of?(Array) and
       args[1].size == 1 and
       REGISTERS.include?(args[1][0]) and
       args[2].kind_of?(::Integer)
      write_instr(LD_POST | GenReg1(args[1][0]) | GenReg2(args[0]) |
           GenBits(0b10, 14, 15) | GenBits(args[2], 0, 13))
    else
      raise ArgumentError.new("Ld incorrect, go ботать toy-isa😭")
    end
  else
    raise ArgumentError.new("Ld incorrect, go ботать toy-isa😭")
  end
end

def add(rd, rs, rt)
  write_instr(ADD | GenReg1(rs) | GenReg2(rt) | GenReg3(rd) |
         GenBits(0b00000, 6, 10) | GenBits(0b011000, 0, 5))
end

def beq(rs, rt, offset)
  if offset.kind_of?(::Integer)
    write_instr(BEQ | GenReg1(rs) | GenReg2(rt) | GenBits(offset, 0, 15))
  elsif offset.kind_of?(Symbol)
    block = proc do |program, instr_count, offset|
      program[instr_count] |= GenBits(offset - instr_count, 0, 15)
    end
    add_fixup(Fixup.new(offset, block, @instr_count))
    write_instr(BEQ | GenReg1(rs) | GenReg2(rt) | GenBits(0, 0, 15))
  else
    raise ArgumentError.new("Incorrect label syntax")
  end
end

def li(rt, imm)
  write_instr(LI | GenBits(0b00000, 21, 25) | GenReg2(rt) | GenBits(imm, 0, 15))
end

def st(*args)
  if args.size == 2 and
    REGISTERS.include? args[0] and
    args[1].kind_of? Array and
    args[1].size == 2 and
    REGISTERS.include? args[1][0] and
    args[1][1].kind_of? ::Integer
      write_instr(ST | GenReg1(args[1][0]) | GenReg2(args[0]) | GenBits(0b00, 14, 15) |
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
    args[2][1].kind_of?(::Integer)
      write_instr(STP | GenReg1(args[2][0]) | GenReg2(args[0]) | GenReg3(args[1]) |
       GenBits(args[2][1], 0, 10))
  else
    raise ArgumentError.new("Stp incorrect, go ботать toy-isa😭")
  end
end

def addi(rt, rs, imm)
  write_instr(ADDI | GenReg1(rs) | GenReg2(rt) | GenBits(imm, 0, 15))
end

def j(addr)
  if addr.kind_of?(::Integer)
    write_instr(J | GenBits(addr, 0, 25))
  elsif addr.kind_of?(Symbol)
    block = proc do |program, instr_count, offset|
      program[instr_count] |= GenBits(offset, 0, 25)
    end
    add_fixup(Fixup.new(addr, block, @instr_count))
    write_instr(J | GenBits(0, 0, 25))
  else
    raise ArgumentError.new("Incorrect label syntax😭")
  end
end

def nor(rd, rs, rt)
  write_instr(NOR | GenReg1(rs) | GenReg2(rt) | GenReg3(rd) |
       GenBits(0b101001, 0, 5))
end

def ssat(rd, rs, imm)
  write_instr(SSAT | GenReg1(rd) | GenReg2(rs) | GenBits(imm, 11, 15) | GenBits(0, 0, 10))
end

def rbit(rd, rs)
  write_instr(RBIT | GenReg1(rd) | GenReg2(rs) | GenBits(0, 6, 15) | GenBits(0b111110, 0, 5))
end

def syscall()
  write_instr(SYSCALL | GenBits(0b010000, 0, 5))
end

def bext(rd, rs1, rs2)
  write_instr(BEXT | GenReg1(rd) | GenReg2(rs1) | GenReg3(rs2) | GenBits(0, 6, 10) |
                GenBits(0b100110, 0, 5))
end

def usat(rd, rs, imm)
  write_instr(USAT | GenReg1(rd) | GenReg2(rs) | GenBits(imm, 11, 15) | GenBits(0, 0, 10))
end

end
