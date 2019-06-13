	.text
	.globl	sqMatPrint
sqMatPrint:							# function to print a 2D matrix in row major manner
	subu	$sp, $sp, 32			# allocate space for stack frame
	sw		$ra, 28($sp)			# save the return address
	sw		$fp, 24($sp)			# save old frame pointer
	add		$fp, $sp, 32			# set up new frame pointer 
	sw		$a1, 20($sp)			# save the address of 2d array in stack
	sw		$a0, 16($sp)			# save the value of n in stack
	mul		$t0, $a0, $a0			# $t0 = n*n i.e. total number of elements
	mul		$t0, $t0, 4				# $t0 = 4*n*n i.e. total number of bytes
	li		$t1, 0					# $t1 = 0 (initialize counter i)
	
	la		$a0, msg3				# load address of msg3 into $a0
	li		$v0, 4					# 4 is the print_string syscall
	syscall							# print msg3
	
	blt		$t1, $t0, loop			# if i < n^2 branch to loop
	b		endloop					# otherwise branch to endloop
	
loop:
	lw		$t2, 20($sp)			# $t2 = address of array A
	add		$t2, $t2, $t1			# $t2 points to (i+1)th element
	lw		$a0, 0($t2)				# a0 = (i+1)th element in row major form of array 
	li		$v0, 1					# 1 is the print_int syscall
	syscall							# print the integer
	
	add		$t1, $t1, 4				# i++
	
	blt		$t1, $t0, aux			# if i < n^2 branch to aux
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
	
	
	
	
	
	
	
	
	
	
	.globl findDet
findDet:							# function to compute the determinant of an n x n matrix
	subu	$sp, $sp, 32			# allocate space for stack frame
	sw		$ra, 28($sp)			# save the return address
	sw		$fp, 24($sp)			# save old frame pointer
	sw		$t4, 8($sp)				# save contents of $t4
	sw		$t5, 4($sp)				# save contents of $t5
	sw		$t6, 0($sp)				# save contents of $t6
	add		$fp, $sp, 32			# set up new frame pointer 	
	
	sw		$a1, 20($sp)			# save address of array A
	sw		$a0, 16($sp)			# save integer n
	
	jal		sqMatPrint				# call to function sqMatPrint	
	
	lw		$t4, 16($sp)			# load n into $t4
	beq		$t4, 1, base			# if n=1 branch to label base (base-case)
	b 		intermediate			# otherwise branch to intermediate
	
base:
	lw		$t0, -12($fp)			# $t0 = address of array A
	lw		$v1, 0($t0)				# $v1 stores return value. $v1 = A[0][0]
	
	la		$a0, msg1				# load address of msg1 into $a0
	li		$v0, 4					# 4 is print_string syscall
	syscall							# print msg1
	
	move	$a0, $v1				# load value of determinant into $a0
	li		$v0, 1					# 1 is print_int syscall
	syscall							# print the determinant in this invocation
	
	la		$a0, msg2				# load address of msg2 into $a0
	li		$v0, 4					# 4 is print_string syscall
	syscall							# print msg2
	
	lw		$ra, -4($fp)			# restore the return address
	lw		$t4, -24($fp)			# restore contents of $t4
	lw		$t5, -28($fp)			# restore contents of $t5
	lw		$t6, -32($fp)			# restore contents of $t6
	subu	$t0, $fp, $sp			# $t0 = size of current stack frame
	lw		$fp, -8($fp)			# restore old frame pointer
	addu	$sp, $sp, $t0			# pop off all elements from the stack frame
	jr		$ra						# return

intermediate:	
	subu	$t4, $t4, 1				# $t4 = n-1
	mul		$t4, $t4, $t4			# $t4 = (n-1)^2
	mul 	$t4, $t4, 4				# $t4 = 4*((n-1)^2)
	subu	$sp, $sp, $t4			# allocate space for co-factor matrix which has (n-1)^2 integers
	
	li		$t0, 0					# $t0 = 0
	sw		$t0, -20($fp)			# M[$fp-20] = 0
	li		$t4, 0					# represents current column index in array A whose co-factor is being computed (let's call it k)
	lw		$t5, -16($fp)			# $t5 = n
	mul 	$t5, $t5, 4				# $t5 = 4*n, acts as an upper limit of row and column counter registers i.e. $t2 and $t3
	li		$t6, 1					# $t6 stores the sign of co-factor of A[0][k] before multiplying it with A[0][k]
	blt		$t4, $t5, loop1			# if k < n branch to loop1
	b		endfunc					# otherwise branch to endfunc
	
loop1:
	li		$t0, 0					# represents current row in co-factor matrix (let's call it i)
	li		$t1, 0					# represents current column in co-factor matrix (let's call it j)
	li		$t2, 0					# represents current row in array A (let's call it r)
	
	blt		$t2, $t5, loop2			# if r < n then branch to loop2
	add		$t4, $t4, 4				# otherwise k = k + 1
	blt		$t4, $t5, loop1			# if k < n branch to loop1
	b		endfunc					# otherwise branch to endfunc
	
loop2:
	bnez	$t2, cond1true			# if r != 0 then branch to cond1true
	add		$t2, $t2, 4				# r = r + 1
	blt		$t2, $t5, loop2			# if r < n then branch to loop2
	b		endloop2				# otherwise branch to endloop2
	
cond1true:
	li		$t3, 0					# represents current column in  array A (let's call it c)
	blt		$t3, $t5, loop3			# if c < n then branch to loop3
	add 	$t2, $t2, 4				# otherwise r = r + 1
	blt		$t2, $t5, loop2			# if r < n then branch to loop2
	b		endloop2				# otherwise branch to endloop2
	
loop3:
	bne		$t3, $t4, cond2true		# if c != k then branch to cond2true
	add 	$t3, $t3, 4				# otherwise c = c + 1
	blt		$t3, $t5, loop3			# if c < n then branch to loop3
	add 	$t2, $t2, 4				# otherwise r = r + 1
	blt		$t2, $t5, loop2			# if r < n then branch to loop2
	b		endloop2				# otherwise branch to endloop2
	
cond2true:
	lw		$t7, -16($fp)			# $t7 = n
	mul		$t7, $t7, $t2			# $t7 = 4*n*r
	add 	$t7, $t7, $t3			# $t7 = (4*n*r)+(4*c)
	lw		$s0, -12($fp)			# $s0 = address of array A
	add		$t7, $t7, $s0			# $t7 = $s0 + (4*n*r) + 4*c
	lw		$t8, 0($t7)				# $t8 = A[r][c]

	lw		$t7, -16($fp)			# $t7 = n
	subu	$t7, $t7, 1				# $t7 = n-1
	mul		$t7, $t7, $t0			# $t7 = 4*i*(n-1)
	add		$t7, $t7, $t1			# $t7 = 4*i*(n-1) + 4*j
	add		$t7, $t7, $sp			# $t7 = $sp + 4*i*(n-1) + 4*j
	sw		$t8, 0($t7)				# Co-factor[i][j] = A[r][c]
	
	add		$t1, $t1, 4				# j = j + 1
	subu	$t7, $t5, 4				# $t7 = 4*(n-1)
	beq		$t1, $t7, cond3true		# if j = n-1 then branch to cond3true
	add 	$t3, $t3, 4				# otherwise c = c + 1
	blt		$t3, $t5, loop3			# if c < n then branch to loop3
	add 	$t2, $t2, 4				# otherwise r = r + 1
	blt		$t2, $t5, loop2			# if r < n then branch to loop2
	b		endloop2				# otherwise branch to endloop2
	
cond3true:
	li		$t1, 0					# j = 0
	add		$t0, $t0, 4				# i = i + 1
	add 	$t3, $t3, 4				# c = c + 1
	blt		$t3, $t5, loop3			# if c < n then branch to loop3
	add 	$t2, $t2, 4				# otherwise r = r + 1
	blt		$t2, $t5, loop2			# if r < n then branch to loop2
	b		endloop2				# otherwise branch to endloop2
	
endloop2:
	lw		$a0, -16($fp)			# $a0 = n
	subu	$a0, $a0, 1				# $a0 = n-1
	move	$a1, $sp				# $a1 = address of Co-factor matrix
	jal		findDet					# call to function findDet
	lw		$s0, -12($fp)			# $s0 = address of array A
	add		$s0, $s0, $t4			# $s0 points to A[0][k]
	lw		$t0, 0($s0)				# $t0 = A[0][k]
	mul 	$s0, $t0, $v1			# $s0 = A[0][k]*findDet(n-1,co-matrix)
	mul		$s0, $s0, $t6			# $s0 = sign*A[0][k]*findDet(n-1,co-matrix)
	lw 		$t0, -20($fp)			# $t0 = partial determinant
	add		$t0, $t0, $s0			# $t0 = partial determinant + sign*A[0][k]*findDet(n-1,co-matrix)
	sw		$t0, -20($fp)			# M[$fp-20] = new partial determinant
	
	beq		$t6, 1, changesign		# if sign = 1 then branch to changesign
	li		$t6, 1					# otherwise sign = 1
	add		$t4, $t4, 4				# k = k + 1
	blt		$t4, $t5, loop1			# if k < n branch to loop1
	b		endfunc					# otherwise branch to endfunc
	
changesign:
	li		$t6, -1					# sign = -1
	add		$t4, $t4, 4				# k = k + 1
	blt		$t4, $t5, loop1			# if k < n branch to loop1
	b		endfunc					# otherwise branch to endfunc
	
endfunc:
	lw		$v1, -20($fp)			# $v1 stores return value. $v1 = determinant of matrix A
	la		$a0, msg1				# load address of msg1 into $a0
	li		$v0, 4					# 4 is print_string syscall
	syscall							# print msg1
	
	move	$a0, $v1				# load value of determinant into $a0
	li		$v0, 1					# 1 is print_int syscall
	syscall							# print the determinant in this invocation
	
	la		$a0, msg2				# load address of msg2 into $a0
	li		$v0, 4					# 4 is print_string syscall
	syscall							# print msg2
	
	lw		$ra, -4($fp)			# restore the return address
	lw		$t4, -24($fp)			# restore contents of $t4
	lw		$t5, -28($fp)			# restore contents of $t5
	lw		$t6, -32($fp)			# restore contents of $t6
	subu	$t0, $fp, $sp			# $t0 = size of current stack frame
	lw		$fp, -8($fp)			# restore old frame pointer
	addu	$sp, $sp, $t0			# pop off all elements from the stack frame
	jr		$ra						# return
	
	
	
	
	
	
	.globl 	main
main:
	subu	$sp, $sp, 32			# allocate space for stack frame
	sw		$ra, 28($sp)			# save the return address
	sw		$fp, 24($sp)			# save old frame pointer
	add		$fp, $sp, 32			# set up new frame pointer
	
	la		$a0, msg4				# load address of msg4 into $a0
	li		$v0, 4					# 4 is the print_string syscall
	syscall							# print the prompt msg4
	
	li		$v0, 5					# load the syscall read_int into $v0
	syscall							# read n
	sw		$v0, 20($sp)			# store n at position $sp + 20 in the stack
	
	la		$a0, msg5				# load address of msg5 into $a0
	li		$v0, 4					# 4 is the print_string syscall
	syscall							# print msg5
	
	li		$v0, 5					# load the syscall read_int into $v0
	syscall							# read s
	sw		$v0, 12($sp)			# store s at position $sp + 12 in the stack
	
	lw		$t0, 20($sp)			# $t0 = n
	mul		$t1, $t0, $t0			# $t1 = n*n
	mul		$t1, $t1, 4				# $t1 = 4*n*n
	
	subu	$sp, $sp, $t1			# allocate space to store array A
	lw		$t0, -20($fp)			# $t0 = s
	sw		$t0, 0($sp)				# A[0] = s
	
	li		$t0, 4					# $t0 stores count of values computed (i=1)
	li		$s0, 330				# $s0 stores value of 'a' i.e. $s0 = 330
	li		$s1, 100				# $s1 stores value of 'c' i.e. $s1 = 100
	li		$s2, 481				# $s2 stores value of 'm' i.e. $s2 = 481
	blt		$t0, $t1, loop4			# branch to loop4
	b		endloop4				# otherwise branch to endloop4
	
loop4:
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
	blt		$t0, $t1, loop4			# branch to loop4
	b		endloop4				# otherwise branch to endloop4
	
endloop4:
	lw		$a0, -12($fp)			# $a0 = n
	move	$a1, $sp				# $a1 = address of array A
	jal		sqMatPrint				# call sqMatPrint
	
	lw		$a0, -12($fp)			# $a0 = n
	move	$a1, $sp				# $a1 = address of array A
	jal		findDet					# call findDet
	
	la		$a0, msg6				# load address of msg6 into $a0
	li		$v0, 4					# 4 is the print_string syscall
	syscall							# print msg6
	
	move	$a0, $v1				# load the value determinant into $a0
	li		$v0, 1					# 1 is the print_int syscall
	syscall							# print the determinant
	
	subu	$sp, $fp, 32			# $sp = $fp - 32 pop off array A
	lw		$ra, 28($sp)			# restore the return address
	lw		$fp, 24($sp)			# restore old frame pointer
	addu	$sp, $sp, 32			# pop off all the elements in the stack frame
	jr		$ra						# return
	
	
	.data
msg:		.asciiz ", "
msg4:		.asciiz "Enter the order of the square matrix whose determinant is to be found \n"
msg2:		.asciiz "\n"
msg3:		.asciiz "The matrix passed on this invocation is :- "
msg1:		.asciiz "The determinant value returned in this invocation is :- "
msg5:		.asciiz "Enter some positive integer for the value of the seed s \n"	
msg6:		.asciiz "Finally the determinant is :- "
	
	
	
	
	
	
	
	
	
	
	
	