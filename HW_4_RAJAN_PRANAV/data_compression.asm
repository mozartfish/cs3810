# Data Compression
# Name: Pranav Rajan
# uID: U1136324
# umail: u1136324@utah.edu

# The program accepts an input string of size less than 40 characters
# and applies run length encoding compression to the string and prints
# the resulting compressed string. The input string only consists of 
# alphabets ie. a-z and A-Z

# The following sources were consulted and used:
# 1) Professor Rajeev Balasubramonian Skeleton
# http://www.cs.utah.edu/~rajeev/cs3810/hw/skel.s.txt
# 2) Appendix A from P&H 5th edition
# 3) Professor Rajeev Balasubramonian MARS Notes
# https://docs.google.com/document/d/15m7ypUuAErcpfcLTzv-efMIfjlYZPH8YkqUTa3oJkHw/edit
# 4) Professor Rajeev Balasubramonian Class Lectures

.data # the data for the program
.align 0 # byte-align the 45 byte space declared next
buffer: .space 45 # allocate 45 bytes as a read buffer for string input
prompt:.asciiz "Please enter a string of size less than 40 characters: "
doh:.asciiz "The characters have to be a-z and A-Z!\n"
.text # read from standard into a character array
.globl main # declare the global main method

main: jal print_prompt # prompt the user, then read how many
                       # values will be input for the array
      jal is_valid     # determine whether the string is valid input
                       
                       
print_prompt: li $v0, 4 # syscall 4 = write string (P&H A-44)
              la $a0, prompt # load the memory address or prompt
              syscall # output the initial prompt
              
              li $v0, 8 # syscall 8 = read string (P&H A-44)
              la $a0, buffer # load the buffer as an argument
              li $a1, 41 # allocate a length of 41 for end line
                         # character and new line character
              move $t0, $a0 # move the contents of the buffer from
                            # register a0 to register t0
              syscall      # read the string
              jr $ra # jump back to the caller

is_valid: addi $sp, $sp, -12 # adjust the stack for 3 variables
	  sw $t0, 8($sp) # save register t0 for use later. Stores the 
	                 # head of the string char array
	  sw $s0, 4($sp) # save register s0 for use later. Stores the
	                 # i value
	  sw $t1, 0($sp) # save register t1 for use later. Store the
	                 # loop tracking value
	  
	  addi $s0, $zero, 0 # update the i counter to 0
	  # addi $t1, $zero, 39 # length of the string
	  
Loop:   addi $t4, $zero, 10 
	sll $t2, $s0, 0 # register t2 = i * 1
         add $t2, $t2, $t0 # address of char[i]
         lb $t3, 0($t2) # register t3 = char[i]
         beq $t3, $t4, Exit # exit if the current character is the new line character
         addi $s0, $s0, 1
         j Loop

Exit:
	 li $v0, 10 # syscall 10 = Exit
	 syscall
	 jr $ra
	  



              
              
              
                        
