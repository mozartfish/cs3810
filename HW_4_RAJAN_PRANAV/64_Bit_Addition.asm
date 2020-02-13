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
prompt: .asciiz "Please enter an unsigned integer: " # null terminated string (P&H A-48)
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
		j print_prompt

	      
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
		
Exit_Main:	li $v0, 10 # syscall 10 = exit (P&H A-44)
		syscall 
		