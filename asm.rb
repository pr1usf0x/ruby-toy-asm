require_relative "isa.rb"

def prog(&block)
    File.open(OUTPUT_NAME, "w")
    block.call
end

begin

prog do
    syscall SCAN_UNSIGNED
    li X2, 0
    li X3, 1

    beq X1, X0, 8

    add X4, X2, X3
    add X2, X3, X0
    add X3, X4, X0
    addi X1, X1, -1
    beq X1, X0, 3
    j 4

    add X1, X2, X0
    syscall PRINT_UNSIGNED
end

rescue => e
    puts e.message
end
