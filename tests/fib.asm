label :start
li X8, SCAN_UNSIGNED
syscall
add X10, X0, X9
li X11, 0
li X12, 1

label :cycle

addi X10, X10, -1
add X13, X11, X12
add X11, X12, X9
add X12, X13, X9
beq X10, X9, :skip
j :cycle
label :skip

add X1, X11, X9
li X8, PRINT_UNSIGNED
syscall
li X8, EXIT
syscall