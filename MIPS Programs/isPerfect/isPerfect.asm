# Aayush Gupta -- 25/8/17
# 56introMIPS.asm -- Perfect Number detection program
# Registers used:
#		$a0 - syscall parameter -- the string to print.
# 		$v0 - syscall parameter and return value. 
#		$t0 - stores the user's input integer (the number to be checked). Let this input be num
# 		$t1 - stores a possible factor (value of $t1 is incremented and then the program checks if it divides the number (stored in $t1)).
#			  Let the value stored in $t1 be divor.
#		$t2 - stores the sum of all divisors at any iteration. Let this value be sum.

		.text
main:	
		# Print the start message
		la		$a0, msg1			# load the address of msg1 into $a0
		li		$v0, 4				# 4 is the print_string syscall
		syscall						# make the system call
		
		# Read the number entered by user and store it in $t0
		li		$v0, 5				# load the syscall read_int into $v0
		syscall						# make the system call
		move	$t0, $v0			# move the number read into $t0
		
		# Initialize $t1 and $t2 to 1 and 0 respectively
		li		$t1, 1				# load the integer 1 into $t1. divor = 1
		li		$t2, 0				# load the integer 0 into $t2. sum = 0
		blt 	$t1, $t0, loop		# if divor < num go to loop
		b		endloop				# otherwise go to endloop
		
		# Loop goes through every integer starting from 1 and checks whether it is a factor of num
loop:	
		div		$t0, $t1			# lo = num/divor  and  hi = num%divor
		mfhi	$t3					# $t3 = hi
		beqz	$t3, inc			# if num%divor = 0 go to inc
		b		count				# otherwise go to count

		# inc updates sum if divor is a factor of num
inc:	
		add		$t2, $t1, $t2		# sum = sum + divor
		b 		count				# go to count
		
		# count increments divor for further checking
count:	
		add		$t1, $t1, 1			# divor = divor + 1
		blt		$t1, $t0, loop		# if divor < num branch to loop
		b 		endloop				# otherwise branch to endloop
		
		# endloop decides whether is perfect or not 
endloop:	beq 	$t0, $t2, yes	# if num = sum branch to yes
			b 		no				# otherwise branch to no
			
yes:	la		$a0, msg2			# load the address of msg2 into $a0
		li		$v0, 4				# 4 is the print_string syscall
		syscall						# make the system call
		
		li		$v0, 10				# syscall code 10 is for exit
		syscall						# make the system call

no:		la		$a0, msg3			# load the address of msg3 into $a0
		li		$v0, 4				# 4 is the print_string syscall
		syscall						# make the system call
		
		li		$v0, 10				# syscall code 10 is for exit
		syscall						# make the system call
	
# Data for the program:	
		.data
msg1:		.asciiz "Enter a positive integer \n"

msg2:		.asciiz "Entered number is a perfect number \n"

msg3:		.asciiz "Entered number is not a perfect number \n"

# end 56introMIPS.asm