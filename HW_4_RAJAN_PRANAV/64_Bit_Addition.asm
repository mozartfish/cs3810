# Data Compression
# Name: Pranav Rajan
# uID: U1136324
# umail: u1136324@utah.edu

# The program accepts 4 unsign(positive) 32 bit integers.
# It reads these 4 integers and returns the 64 bit result of ((A * B) + (C * D))
# Register t8 contains the most significant 32 bits and Register t9 contains
# the least significant 32 bits

# The following sources were consulted and used:
# 1) Appendix A from P&H 5th edition
# 2) Professor Rajeev Balasubramonian MARS Notes
# https://docs.google.com/document/d/15m7ypUuAErcpfcLTzv-efMIfjlYZPH8YkqUTa3oJkHw/edit
# 3) Professor Rajeev Balasubramonian Class Lectures

.data #  store the items below this line in the data segment(P&H A-48, A-21)
buffer: .align 0 # align data elements to appropriate memory boundaries (MARS Notes)
	.space 45 # allocate 45 bytes as a read buffer for string input (MARS Notes)
prompt: .asciiz "Please enter an unsigned integer:\n" # null terminated string (P&H A-48)
exit_statement: .asciiz "The end of the program.\n" # null terminated string (P&H A-48) # for debugging purposes
.text # store the items below this line (Program Instructions) in the text segment (P&H A-21)
.globl main # declare that main is global and can be referenced from other files (P&H A-48, A-47)

main:	addi $t1, $zero, 0 # set i counter to 1
	li $t2, 0 # store 0 in register t2
	li $t3, 1 # store 1 in register t3
	li $t4, 2 # store 2 in register t4
	li $t5, 3 # store 3 in register t5
	li $t6, 4 # store 4 in register t6
	jal get_elements # jump to procedure to get elements for computation
	jal multiply # jump to procedure to multiply the elements
	jal check_and_set # jump to the check and set procedure
      j Exit_Main # jump to the end of the main procedure
 
print_prompt:	li $v0, 4 # syscall 4 = write string (P&H A-44)
		la $a0, prompt # load the memory address of the prompt string (MARS Notes)
		syscall # print the string declared at label prompt (MARS Notes)
		li $v0, 5 # syscall 5 = read signed integer (32-bit)(P&H A-44)
		syscall
		beq $t1, $t2, store_1 # if i = 0 jump to store 1
		beq $t1, $t3, store_2 # if i = 1 jump to store 2
		beq $t1, $t4, store_3 # if i = 2 jump to store 3
		beq $t1, $t5, store_4 # if i = 3 jump to store 4
		
get_elements: 
Loop:		beq $t1, $t6, Exit_Loop # check if i = 4
		j print_prompt # call the print prompt label
		
Exit_Loop:	jr $ra # jump back to the caller

store_1:	add $s0, $zero, $v0 # save register v0 value to register s0
		addi $t1, $t1, 1 # i = i + 1
		j Loop # jump back to loop
		
store_2:	add $s1, $zero, $v0 # save register v0 value to register s1
		addi $t1, $t1, 1 # i = i + 1
		j Loop # jump back to loop
		
store_3:	add $s2, $zero, $v0 # save register v0 value to register s2
		addi $t1, $t1, 1 # i = i + 1
		j Loop # jump back to loop
		
store_4:	add $s3, $zero, $v0 # save register v0 value to register 
		addi $t1, $t1, 1 # i = i + 1
		j Loop

multiply:	multu $s0, $s1 # multiply the first two numbers (P&H A-53)
		mflo $s4 # move the lower 32-bits to register s4 (P &H A-71)
		mfhi $s5 # move the higher 32-bits to register s5 (P&H A-71)
		multu $s2, $s3 # multiply the second two numbers (P&H A-53)
		mflo $s6 # move the lower 32-bits to register s6 (P&H A-71)
		mfhi $s7 # move the higher 32-bits to register s7
		jr $ra # jump back to the caller

check_and_set:	li $t1, 1 # load 1 into register t3
		srl $t2, $s4, 30 # shift 30 units to the right for lower-32 bits to get 1 significant value
		srl $t3, $s6, 30 # shift 30 units to the right for lower 32-bits to get 1 significant value
		beq $t2, $t1, check_2 # if value in register t2 = 1 jump to second check
		j check_3 # jump to the third check

check_2:	beq $t3, $t1, carry_sum # if value in register t3 is also 1 then do the carry sum
		addu $t9, $s4, $s6 # store the sum of the lower 32 bits in register t9
		addu $t8, $s5, $s7 # store the sum of the upper 32 bits in register t8
		jr $ra # jump back to the caller

check_3:	srl $t2, $s4, 1	 # shift right once to see if there is a carry
		srl $t3, $s6, 1 # shift right once to see if there is a carry
		addu $t4, $t2, $t3 # compute the sum
		li $t5, 1 # load 1 into register t5
		srl $t6, $t4, 30 # shift right 30 units for the sum in $t4 to check if there is a carry 
		beq $t6, $t5, carry_sum # if the most significant bit is 1, jump to carry sum
		addu $t9, $s4, $s6 # store the sum of the lower 32 bits in register t9
		addu $t8, $s5, $s7 # store the sum of the upper 32 bits in register t8
		jr $ra # jump back to the caller

carry_sum:	li $t1, 1 # load 1 into register t1
		addu $t9, $s4, $s6 # store the sum of the lower 32 bits in register t9
		addu $t8, $s5, $s7 # store the sum of the upper 32 bits in register t8
		addu $t8, $t8, $t1 # add the carry term
		jr $ra # jump back to the caller
		
Exit_Main:	li $v0, 10 # syscall 10 = exit (P&H A-44)
		syscall 
		