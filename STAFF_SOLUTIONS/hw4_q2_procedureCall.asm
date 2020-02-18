##################################################################################
#			  PSEUDO CODE
#			***************
#
# STEP-1: Find the length of the input string.
#		(a) Read through the buffer and find the NULL terminator "\0".
#		(b) Keep incrementing the counter (initialized to zero) until NULL terminator is detected.
#		(c) Terminate the loop after the successful detection of "\0".
#		(d) The value of counter after step-c should be the length of the string.
# STEP-2: Create a nested loop to perform compression as shown in pseudo code below.
#
#	k = 0;
#	for (i = 0; i < string_length; i++){
#		current_count = 1 					// current_count keeps track of the number of times each character is repeated
#		for (j = 0; j < string_length; j++){			// i and j represent the pointers to a specific address location in the buffer at which the string is stored.
#			if (string[i] != string[j]){			// if the value in addresses i and j do not match, it means that the entry in 'i' is the last instance of that character.
#				if (current_count > 1){			// condition to make sure a single characters count is not printed.
#					a[k] = string[i];
#					k++;
#					Function Convert_ItoA (current_count)	//Convert integer value of current_count to string to load it in to the buffer
#					a[k] = current_count_quotient;
#					k++;
#					a[k] = current_count_reminder;
#					k++;
#				} else {
#					a[k] = string[i];
#					k++;
#				}
#				i = j;					// move both the pointers to the starting position of the next character
#				break;
#			}
#			current_count++;
#		}
#	}
#
# CONVERT INTEGER TO ASCII:
#	(a) As the maximum size of the character string is 40, compressed integers can only be two digit values.
#	(b) Divide the integer by 10 and store the quotient and reminder.
#	(c) Add the number 48 to both quotient and reminder to convert them into their respective ASCII representation.
#	(d) Load the quotient first and then the reminder to the string array.
#
# SAVE/RESTORE PROCEDURE CALL EXAMPLE: between labels inner_loop and processB
##################################################################################






.data

		# call this array A	
		.align 0		# byte-align the 40 byte space declared next
buffer1:	.space 40		# allocate 40 bytes as a read buffer for string input

		# call this array B	
		.align 0		# byte-align the 40 byte space declared next
buffer2:	.space 40		# allocate 40 bytes as a read buffer for string input


prompt:	.asciiz "Enter up to 39 characters: "

space:		.asciiz " "

.text

		
		li $v0, 4		# syscall reads this reg when called, 4 means print string
		la $a0, prompt		# load the address of the string declared at .data
		syscall			# print the string declared at label prompt in .data
		
		li $v0, 8		# syscall reads this reg when called, 8 means read string
		la $a0, buffer1		# load the address of the buffer to write into from stdin
		li $a1, 40		# load the length of the buffer in bytes in $a1
		syscall

#Sanity check to verify the value of the input string		
#		li $v0, 4		# syscall reads this reg when called, 4 means write string
#		la $a0, buffer1		# load the address of the buffer to read from to stdout
#		syscall

		addi $s1, $0, 0
		addi $s0, $0, 0		#$s0 stores the ascii value of the NULL terminator
		
		la $t1, buffer1		#intial address of buffer1 (containing the input string) is stored in $t1

# input_loop and loop_length are used to calculate the length of the string

input_loop:
		add $t2, $s1, $t1
		lb $t2, 0($t2)
		beq $t2, $s0, loop_length	# NULL Terminator check
		addi $s1, $s1, 1
		j input_loop			# run the loop until NULL terminator is detected

loop_length:					# sanity check to print the length of the string
#		addi $a0, $s1, 0
#		li $v0, 1
#		syscall


# STEP 2 of the pseudo code starts here
		la $t2, buffer2			# load the base address of array B declared above into $t2
		addi $s7, $0, 0			# initializing k=0 as given in the pseudo code
		addi $s3, $0, 0			# i in upper loop
upper_loop:					# for loop in the pseudo code with incrementing 'I'
		beq $s3, $s1, exit_upper_loop	
		addi $t3, $0, 1 		# current_count = 1
		addi $s4, $s3, 1 		# j in inner loop
inner_loop:
		beq $s4, $s1, exit_inner_loop
		add $t4, $s3, $t1 		# address string[i]
#		add $t5, $s4, $t1 		# address string[j]
		lb $t6, 0($t4)
#		lb $t7, 0($t5)
		addi $sp, $sp, -8
		sw $t4, 4($sp)
		sw $ra, 0($sp)

		jal processB

		lw $t4, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 8		

		bne $t6, $t7, print_statement
		
		addi $t3, $t3, 1		#current_count++
		addi $s4, $s4, 1 		# j++
		j inner_loop
exit_inner_loop:
		addi $s3, $s4, 0 		# i = j
		j upper_loop

processB:
		add $t4, $s4, $t1
		lb $t7, 0($t4)
		jr $ra
				
print_statement:
		addi $t7, $0, 1
		bgt $t3, $t7, compress

		lbu $t9, ($t4)		#load the character into string
		add $t8, $s7, $t2
		sb $t9, 0($t8)
		addi $s7, $s7, 1
		j exit_inner_loop
		
compress:
#		li $v0, 11		#Sanity check to verify the char value
#		lbu $a0, ($t4)
#		syscall
		
#		li $v0, 1		#Sanity check to verify the integer value of count
#		addi $a0, $t3, 0
#		syscall

		lbu $t9, ($t4)		#load the character into string
		add $t8, $s7, $t2
		sb $t9, 0($t8)
		addi $s7, $s7, 1

		addi $t0, $0, 10	#t0 = 10
		div $t3, $t0		#current_count/10
		mflo $s5		#Quotient
		mfhi $s6		#Reminder

		beqz $s5, load_reminder	#do not load the quotient into the string if it is zero
		addi $s5, $s5, 48	#convert quotient to ASCII

		add $t8, $s7, $t2	#load the quotient into string
		sb $s5, 0($t8)
		addi $s7, $s7, 1

load_reminder:
		addi $s6, $s6, 48	#convert reminder to ASCII
		add $t8, $s7, $t2	#load the reminder into string
		sb $s6, 0($t8)
		addi $s7, $s7, 1
		
		j exit_inner_loop
		
exit_upper_loop:
		add $t8, $s7, $t2	#add NULL terminator to the string
		sb $0, 0($t8)

		li $v0, 4		# syscall reads this reg when called, 4 means write string
		la $a0, buffer2		# load the address of the buffer to read from to stdout
		syscall
