.data

str: .asciiz "BOO"
myint: .word 12

.text

li $v0, 4 # load immediate; 4 is the code for print_string
la $a0, str # the print_string syscall expects the string
# address as the argument; la is the instruction
# to load the address of the operand (str)
syscall # MARS will now invoke syscall-4.
# This should print the string on the bottom of the screen.
lb $t1, ($a0) # load the byte at address $a0 into register $t1
lb $t2, 1($a0) # load the byte at address $a0+1 into register $t2
lb $t3, 2($a0) # load the byte at address $a0+2 into register $t3
li $v0, 1 # syscall-1 corresponds to print_int
lw $a0, myint # Bring the value at label myint to register $a0.
# print_int expects the integer to be printed in $a0.
syscall # MARS will now invoke syscall-1 