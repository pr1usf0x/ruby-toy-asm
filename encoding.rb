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