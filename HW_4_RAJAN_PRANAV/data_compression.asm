# Data Compression
# Name: Pranav Rajan
# uID: U1136324
# umail: u1136324@utah.edu

# The program accepts an input string of size less than 40 characters
# and applies run length encoding compression to the string and prints
# the resulting compressed string. The input string only consists of 
# alphabets ie. a-z and A-Z

# The following sources were consulted and used:
# 1) Appendix A from P&H 5th edition
# 2) Professor Rajeev Balasubramonian MARS Notes
# https://docs.google.com/document/d/15m7ypUuAErcpfcLTzv-efMIfjlYZPH8YkqUTa3oJkHw/edit
# 3) Professor Rajeev Balasubramonian Class Lectures
# 4) Duke University MIPS Examples
# https://users.cs.duke.edu/~raw/cps104/TWFNotes/mips.html

.data #  store the items below this line in the data segment(P&H A-48, A-21)
buffer: .align 0 # align data elements to appropriate memory boundaries (MARS Notes)
	.space 45 # allocate 45 bytes as a read buffer for string input (MARS Notes)
prompt: .asciiz "Please enter a string of size less than 40 characters: " # null terminated string (P&H A-48)
error_prompt: .asciiz "The characters have to be a-z and A-Z!\n" # null terminated string (P&H A-48)
empty_prompt: .asciiz "An empty string was entered!\n" # null terminated string (P&H A-48)
exit_statement: .asciiz "The string contains valid input"
.text # store the items below this line (Program Instructions) in the text segment (P&H A-21)
.globl main # declare that main is global and can be referenced from other files (P&H A-48, A-47)

main: jal print_prompt # prompt the user for input
      jal is_valid # check if the input is valid
                       
print_prompt:	li $v0, 4 # syscall 4 = write string (P&H A-44)
		la $a0, prompt # load the memory address of the prompt string (MARS Notes)
		syscall # print the string declared at label prompt (MARS Notes)
             
		li $v0, 8 # syscall 8 = read string (P&H A-44)
		la $a0, buffer # load the address of the buffer to write from stdin (MARS Notes)
		li $a1, 41 # allocate a length of 41 for the new line character and terminating character (Duke MIPS Examples)
		move $s0, $a0 # move the address of the buffer to register s0 for use later
		syscall # read the string into the buffer (located at register a0) and move it to register s0
		jr $ra # jump back to the caller (main label)
		
is_valid:	addi $sp, $sp, -4 # adjust the stack for 1 variable
		sw $s0, 4($sp) # save register s0 for use later. Stores the address for head of char array
		
		addi $s1, $zero, 0 # initialize the i counter to 0
		addi $s2, $zero, 0 # initialize a variable to keep track of the previous character
		addi $t1, $zero, 10 # register t1 = 10. Stores the ASCII value for new line feed
		
Loop:		sll $t2, $s1, 0 # register t2 = i * 1 (P&H 92)
		add $t2, $t2, $s0 # register t2 = address of char[i]
		lb $t3, 0($t2) # register t3 = current char[i]
		beq $t3, $t1, empty_check # jump to empty check if current char[i] = 10 => 10 = ASCII new line feed
		j check_1 # jump to the first check
		j Loop # jump back to the top of the loop
		
empty_check:	bne $s2, $zero, Exit_Loop # if the previous character was not null (ASCII 0) exit the loop
		li $v0, 4 # syscal 4 = write string
		la $a0, empty_prompt # load the address of empty string prompt
		syscall # write string
		li $v0, 10 # syscall 10 = exit
		syscall # exit the procedure

check_1:	slti $t4, $t3, 65 # check if current char[i] < 65 => A = 65
				  # 1 if register t3 value < 65
				  # 0 otherwise
		bne $t4, $zero, Error_Message # if 1, return error message
						# Otherwise continue to next check
		j check_2 # jump to the second check

check_2:	slti $t4, $t3, 97 # check if current char[i] < 97 => a = 97
			          # 1 if register t3 value < 97
			          # 0 otherwise
		bne $t4, $zero, check_3 # if 1 jump to check_3
					# Otherwise continue to next check
		j check_4 # jump to fourth check
		
check_3:
		addi $t5, $zero, 90 # set register t5 to 90 => Z = 90
		sgt $t6, $t3, $t5 # if check if current char[i] > 90
				  # 1 if register t6 value > 90
				  # 0 otherwise
		bne $t6, $zero, Error_Message # if 1, return error message



check_4:	addi $t4, $zero, 122
		sgt $t5, $t3, $t4 # check if current char[i] > 122 => z = 122
				  # 1 if register t3 value > 122
				  # 0 otherwise
		bne $t5, $zero, Error_Message # if 1, return error message
		add $s2, $zero, $t3 # add the value of register t3 to register s2
		addi $s1, $s1, 1 # i = i + 1
		j Loop # jump back to the loop

Error_Message:	li $v0, 4 # syscall 4 = write string (P&H A-44)
		la $a0, error_prompt # load the address of the error message
		syscall # write the error message
		li $v0, 10 # syscall 10 = exit (P&H A-44)
		syscall # quit the program
		
		
Exit_Loop:	li $v0, 4 # syscall 4 = write string (P&H A-44)
		la $a0, exit_statement # load the address for the exit statement
		syscall # write the exit statement
		lw $s0, 4($sp) # rstore register s0 to caller
		addi $sp, $sp, 4 # adjust stack to delete 1 item
		jr $ra # jump back to caller
		


	




              
              
                        
