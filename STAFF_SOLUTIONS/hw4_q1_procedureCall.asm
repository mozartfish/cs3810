.data
   start: .asciiz "In this program, please enter 4 numbers, press return to continue.\n"
   askA: .asciiz "Please enter A: "
   askB: .asciiz "Please enter B: "
   askC: .asciiz "Please enter C: "
   askD: .asciiz "Please enter D: "
   print_t8: .asciiz "The most significant 32 bits of 64 bits result in $t8: "
   print_t9: .asciiz "The least significant 32 bits of 64 bits result in $t9: "
   newLine: .asciiz "\n"



.text
bitsAdd:
	li  $v0,4		# code 4, print string         
    	la  $a0,start 
    	syscall
    	
    	
	li  $v0,4           
    	la  $a0,askA 
    	syscall 
    	
    	li  $v0,5		# read number A         
   	syscall 
   	
   	move $t0, $v0		# move the input A from $v0 to $t0
   	
   	li  $v0,4           
    	la  $a0,askB
    	syscall 
    	
    	li  $v0,5 		# read number B         
   	syscall 
   	
   	move $t1, $v0		# move the input B from $v0 to $t1
   	
   	li  $v0,4           
    	la  $a0,askC
    	syscall 
    	
    	li  $v0,5		# read number C          
   	syscall 
   	
   	move $t2, $v0		# move the input C from $v0 to $t2
   	
   	li  $v0,4           
    	la  $a0,askD 
    	syscall 
    	
    	li  $v0,5		# read number D          
   	syscall 
   	
   	move $t3, $v0		# move the input D from $v0 to $t3
	
	multu $t0, $t1		# A*B
	mflo $t4  		# move the value from lo register to $t4
	mfhi $t5 		# move the value from hi register to $t5
	
	multu $t2, $t3		# C*D
	mflo $t6		# move the value from lo register to $t6
	mfhi $t7		# move the value from lo register to $t7
	
	addi $sp, $sp, -4	# grow the stack
	sw $ra, 0($sp)		# store the return address, just in case other function will call this bitsAdd as a function
	
	jal setCarryin		# jump to setCarryin function 
	
	lw $ra, 0($sp)		# restore $ra from stack
	add $sp, $sp, 4		# shrink the stack
	
	move $t9, $v0		# move the first return value to $t9
	move $t8, $v1		# move the second return value to $t8
	
	li  $v0,4           
    	la  $a0,print_t8 
    	syscall
    	
	move    $a0,$t8                 
    	li      $v0,34		#code 34, print hex      
    	syscall
    	
    	li  $v0,4           
    	la  $a0,newLine
    	syscall
    	
    	li  $v0,4           
    	la  $a0,print_t9
    	syscall
    	
    	
    	move    $a0,$t9                
    	li      $v0,34 
    	syscall
    	
    	li	$v0,10
    	syscall
	
	

setCarryin:
	addu $v0, $t4, $t6	# add the least significant bits of A*B and C*D
	sltu $v1, $v0, $t4	# check whether it has carry-in bit or not 
				# the reason is if $v0 (the sum of two low 32 bits) is less than either $t4 or $t6, it means there is a carryin bit generated
				# and if it has carryin bit generated, $v1 will be 1 as the carry-in bit, otherwise it will be 0.
	addu $v1, $v1, $t5	# add the carry-in bit with the most significant 32 bits of the A*B
	addu $v1, $v1, $t7	# add the result from the previous step with the most significant bits of C*D
	
	jr $ra
	
