	.text
	.globl	matPrint
matPrint:							# function to print a 2D matrix in row major manner
	subu	$sp, $sp, 32			# allocate space for stack frame
	sw		$ra, 28($sp)			# save the return address
	sw		$fp, 24($sp)			# save old frame pointer
	add		$fp, $sp, 32			# set up new frame pointer 
	sw		$a2, 20($sp)			# save the address of 2d array in stack
	sw		$a1, 16($sp)			# save the value of n in stack
	sw		$a0, 12($sp)			# save the value of m in stack
	mul		$t0, $a0, $a1			# $t0 = m*n i.e. total number of elements (let l be the total elements)
	mul		$t0, $t0, 4				# $t0 = 4*m*n i.e. total number of bytes
	li		$t1, 0					# $t1 = 0 (initialize counter i)
	blt		$t1, $t0, loop			# if i < l branch to loop
	b		endloop					# otherwise branch to endloop
	
loop:
	lw		$t2, 20($sp)			# $t2 = address of array A
	add		$t2, $t2, $t1			# $t2 points to (i+1)th element
	lw		$a0, 0($t2)				# a0 = (i+1)th element in row major form of array 
	li		$v0, 1					# 1 is the print_int syscall
	syscall							# print the integer
	
	add		$t1, $t1, 4				# i++
	
	blt		$t1, $t0, aux			# if i < l branch to aux
	b		endloop					# otherwise branch to endloop
	
aux:
	la		$a0, msg				# load address of msg i.e. ", " into $a0
	li		$v0, 4					# 4 is print_string syscall
	syscall							# print msg
	
	b		loop					# branch to loop
	
endloop:
	la		$a0, msg2				# load address of msg2 into $a0
	li		$v0, 4					# 4 is the print_string syscall
	syscall							# print msg2
	
	lw		$ra, 28($sp)			# restore the return address
	lw		$fp, 24($sp)			# restore old frame pointer
	addu	$sp, $sp, 32			# pop off all the elements in the stack frame
	jr		$ra						# return
	
	.globl	matTrans
matTrans:							# function to compute the transpose of a 2D matrix A and store it in a 2D matrix B
	subu	$sp, $sp, 32			# allocate space for stack frame
	sw		$ra, 28($sp)			# save the return address
	sw		$fp, 24($sp)			# save old frame pointer
	add		$fp, $sp, 32			# set up new frame pointer
	sw		$a3, 20($sp)			# save the address of 2d array B in stack
	sw		$a2, 16($sp)			# save the address of 2d array A in stack
	sw		$a1, 12($sp)			# save the value of n in stack
	sw		$a0, 8($sp)				# save the value of m in stack
	mul		$a0, $a0, 4				# $a0 = 4*m
	mul		$a1, $a1, 4				# $a1 = 4*n
	li		$t0, 0					# initialize i to 0
	li		$t1, 0					# initialize j to 0
	blt		$t0, $a0, loop1			# if i < m branch to loop1
	b		endloop1				# otherwise branch to endloop1
	
loop1:
	blt		$t1, $a1, loop2			# if j < n branch to loop2
	add		$t0, $t0, 4				# otherwise i++
	li		$t1, 0					# j = 0
	blt		$t0, $a0, loop1			# if i < m branch to loop1
	b		endloop1				# otherwise branch to endloop1
	
loop2:
	add		$t3, $sp, 16			# $t3 points to address of array A
	lw		$t2, 0($t3)				# $t2 = address of array A
	lw		$t3, 12($sp)			# $t3 = n
	mul		$t3, $t0, $t3			# $t3 = n*i
	add		$t3, $t3, $t1			# $t3 = $t3 + j
	add		$t2, $t2, $t3			# $t2 points to ((n*i)+j+1)th element in row major form of A
	lw		$s0, 0($t2)				# $s0 = ((n*i)+j+1)th element in row major form of A
	
	add		$t3, $sp, 20			# $t3 points to address of array B
	lw		$t2, 0($t3)				# $t2 = address of array B
	lw		$t3, 8($sp)				# $t3 = m
	mul		$t3, $t1, $t3			# $t3 = m*j
	add		$t3, $t3, $t0			# $t3 = $t3 + i
	add		$t2, $t2, $t3			# $t2 points to ((m*j)+i+1)th element in row major form of B
	sw		$s0, 0($t2)				# content of $s0 is stored at ((m*j)+i)th position in the stack
	
	add		$t1, $t1, 4				# j++
	
	blt		$t1, $a1, loop2			# if j < n branch to loop2
	b		loop1					# otherwise branch to loop1
	
endloop1:
	lw		$ra, 28($sp)			# restore the return address
	lw		$fp, 24($sp)			# restore old frame pointer
	addu	$sp, $sp, 32			# pop off all the elements in the stack frame
	jr		$ra						# return
	
	.globl 	main
main:
	subu	$sp, $sp, 32			# allocate space for stack frame
	sw		$ra, 28($sp)			# save the return address
	sw		$fp, 24($sp)			# save old frame pointer
	add		$fp, $sp, 32			# set up new frame pointer
	
	la		$a0, msg1				# load address of msg1 into $a0
	li		$v0, 4					# 4 is the print_string syscall
	syscall							# print the prompt msg1
	
	li		$v0, 5					# load the syscall read_int into $v0
	syscall							# read m
	sw		$v0, 20($sp)			# store m at position $sp + 20 in the stack
	
	li		$v0, 5					# load the syscall read_int into $v0
	syscall							# read n
	sw		$v0, 16($sp)			# store n at position $sp + 16 in the stack

	li		$v0, 5					# load the syscall read_int into $v0
	syscall							# read s
	sw		$v0, 12($sp)			# store s at position $sp + 12 in the stack
	
	lw		$t0, 20($sp)			# $t0 = m
	lw		$t1, 16($sp)			# $t1 = n
	mul		$t1, $t1, $t0			# $t1 = m*n
	mul		$t1, $t1, 4				# $t1 = 4*m*n
	
	subu	$sp, $sp, $t1			# $sp = $sp - $t1
	subu	$sp, $sp, $t1			# $sp = $sp - $t1
	lw		$t0, -20($fp)			# $t0 = s
	sw		$t0, 0($sp)				# A[0] = s
	
	li		$t0, 4					# $t0 stores count of values computed (i=1)
	li		$s0, 330				# $s0 stores value of 'a' i.e. $s0 = 330
	li		$s1, 100				# $s1 stores value of 'c' i.e. $s1 = 100
	li		$s2, 481				# $s2 stores value of 'm' i.e. $s2 = 481
	blt		$t0, $t1, loop3			# branch to loop3
	b		endloop3				# otherwise branch to endloop3
	
loop3:
	subu	$t2, $t0, 4				# $t2 = i-1
	add		$t2, $t2, $sp			# $t2 = $sp + i-1
	lw		$t3, 0($t2)				# $t3 = A[i-1]
	mul		$t3, $t3, $s0			# $t3 = a*A[i-1]
	add 	$t3, $t3, $s1			# $t3 = a*A[i-1] + c
	div		$t3, $s2				# hi = ($t3)%481
	mfhi	$t3						# $t3 = (a*A[i-1] + c)mod 481
	add		$t2, $sp, $t0			# $t2 = $sp + i
	sw		$t3, 0($t2)				# A[i] = (a*A[i-1] + c)mod 481
	add		$t0, $t0, 4				# i++
	blt		$t0, $t1, loop3			# branch to loop3
	b		endloop3				# otherwise branch to endloop3
	
endloop3:
	la		$a0, msg3				# load address of msg3 into $a0
	li		$v0, 4					# 4 is the print_string syscall
	syscall							# print msg3

	lw		$a0, -12($fp)			# $a0 = m
	lw		$a1, -16($fp)			# $a1 = n
	move	$a2, $sp				# $a2 = address of array A
	jal		matPrint				# call matPrint
	
	lw		$a0, -12($fp)			# $a0 = m
	lw		$a1, -16($fp)			# $a1 = n
	move	$a2, $sp				# $a2 = address of array A
	mul		$t1, $a0, $a1			# $t1 = m*n
	mul		$t1, $t1, 4				# $t1 = 4*m*n
	add		$a3, $sp, $t1			# $a3 = address of array B
	jal		matTrans				# call matTrans	
	
	la		$a0, msg4				# load address of msg4 into $a0
	li		$v0, 4					# 4 is the print_string syscall
	syscall							# print msg4
	
	lw		$a0, -12($fp)			# $a0 = m
	lw		$a1, -16($fp)			# $a1 = n
	mul		$t1, $a0, $a1			# $t1 = m*n
	mul		$t1, $t1, 4				# $t1 = 4*m*n
	add		$a2, $sp, $t1			# $a2 = address of array B
	jal		matPrint				# call matPrint
	
	subu	$sp, $fp, 32			# $sp = $fp - 32 pop off arrays A and B
	lw		$ra, 28($sp)			# restore the return address
	lw		$fp, 24($sp)			# restore old frame pointer
	addu	$sp, $sp, 32			# pop off all the elements in the stack frame
	jr		$ra						# return
	
	.data
msg:		.asciiz ", "
msg1:		.asciiz "Enter three positive integers m, n and s \n"
msg2:		.asciiz "\n"
msg3:		.asciiz "Elements of array A (in row major manner) are :- "
msg4:		.asciiz "Elements of array B (in row major manner) are :- "