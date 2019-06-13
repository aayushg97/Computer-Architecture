	.text
	.globl main							# main is a global name 
main:									# start of main
	subu	$sp, $sp, 24				# allocate 24 bytes for stack frame
	sw		$ra, 12($sp)				# store return address
	sw		$fp, 8($sp)					# store old frame pointer
	addu	$fp, $sp, 20				# set up frame pointer
	la		$a0, msg					# load address of msg into a0
	li		$v0, 4						# 4 is print_string syscall
	syscall								# make the system call and print msg
	li		$v0, 5						# load the syscall read_int into $v0
	syscall								# make the system call and read k
	sw		$v0, 0($sp)					# M[sp] = k
	
	mul		$v0, $v0, 4					# $v0 = 4*k
	move	$t0, $v0					# $t0 = 4*k
	subu	$sp, $sp, $t0				# allocate space for k sized array
	
	la		$a0, msg1					# load address of msg1 into a0
	li		$v0, 4						# 4 is print_string syscall
	syscall								# Print the prompt msg1
	li		$v0, 5						# load the syscall read_int into $v0
	syscall								# read n
	add		$t3, $sp, $t0				# $t3 = $sp + $t0 = $sp + 4*k
	sw		$v0, 4($t3)					# m[sp+4*k+4] = v0 = n
	mul		$t2, $v0, 4					# $t2 = 4*n
	
	li		$t1, 0						# $t1 stores count of elements read
	b		kread						# branch to kread
	
kread:
	la		$a0, msg2					# load address of msg2 into $a0
	li		$v0, 4						# 4 is print_string syscall
	syscall								# make the syscall and print msg2
	
	li		$s3, 4						# $s3 = 4
	div		$t1, $s3					# lo = ($t1)/4  and  hi = ($t1)%4
	mflo	$s3							# $s3 = ($t1)/4
	add		$a0, $s3, 1					# $a0 = $s3 + 1
	li		$v0, 1						# 1 is the print_int syscall
	syscall								# make the syscall and print contents of $a0
	
	la		$a0, msg7					# load address of msg7 into $a0
	li		$v0, 4						# 4 is print_string syscall
	syscall								# make the syscall to print msg7
	
	li		$v0, 5						# load the syscall read_int into $v0
	syscall								# read an element
	add		$t3, $sp, $t1				# $t3 = $sp + $t1
	sw		$v0, 0($t3)					# store the ($t1+1)th element in the stack
	addu	$t1, $t1, 4					# increment count
	blt		$t1, $t0, kread				# if count < k read next element
	b 		nread						# otherwise branch to nread

nread:
	bge		$t1, $t2, endnread			# if count >= n then branch to endnread
	la		$a0, msg2					# load address of msg2 into $a0
	li		$v0, 4						# 4 is print_string syscall
	syscall								# make the syscall and print
	
	li		$s3, 4						# $s3 = 4
	div		$t1, $s3					# lo = ($t1)/4  and  hi = ($t1)%4
	mflo	$s3							# $s3 = ($t1)/4
	add		$a0, $s3, 1					# $a0 = $s3 + 1
	li		$v0, 1						# 1 is the print_int syscall
	syscall								# make the syscall to print $a0
	
	la		$a0, msg7					# load address of msg7 into $a0
	li		$v0, 4						# 4 is print_string syscall
	syscall								# make the syscall to print msg7
	
	li		$v0, 5						# load the syscall read_int into $v0
	syscall								# read an element
	addu	$t1, $t1, 4					# $t1 = $t1 + 4 (count++)
	move	$s1, $v0					# store number scanned in s1
	
	li		$a0, 0						# (i=0) initialize counter to traverse through k sized array
	li		$a1, -1						# index of min
	move	$a2, $s1					# $a2 stores min number in array
	b		loop						# branch to loop
	
loop:
	addu	$t3, $sp, $a0				# $t3 = $sp + i
	lw		$s0, 0($t3)					# (i+1)th number in array
	blt		$s0, $a2, update			# if arr[i] < min branch to update 
	addu	$a0, $a0, 4					# i++
	blt		$a0, $t0, loop              # if i < k branch to loop
	b		endloop						# otherwise branch to endloop
	
update:
	move	$a1, $a0					# index = i
	addu	$t3, $sp, $a0				# $t3 = $sp + $a0
	lw 		$a2, 0($t3)					# min = arr[i]
	addu	$a0, $a0, 4					# i++
	blt		$a0, $t0, loop				# if i < k branch to loop
	b		endloop						# otherwise branch to endloop
	
endloop:
	bgez	$a1, upda					# if index >= 0 branch to upda
	b		nread						# othrwise branch to nread
	
upda:
	addu	$t3, $sp, $a1				# $t3 = $sp + index
	sw		$s1, 0($t3)					# $s1 = arr[index]
	b		nread						# branch to nread
	
endnread:
	lw		$s2, 0($sp)					# $s2 = arr[0]
	li		$t1, 4						# initialize a variable i = 1
	b		mini						# branch to mini
	
mini:
	add		$t3, $sp, $t1				# $t3 = $sp + $t1
	lw		$s0, 0($t3)					# (i+1)th element is stored in $s0
	blt		$s0, $s2, upd				# if arr[i] > min then branch to upd
	addu	$t1, $t1, 4					# otherwise i++
	blt		$t1, $t0, mini				# if i < k then branch to mini
	b 		endmain						# otherwise branch to endmain
	
upd:
	add		$t3, $sp, $t1				# $t3 = $sp + i
	lw		$s2, 0($t3)					# $s2 = arr[i]
	addu	$t1, $t1, 4					# i++
	blt		$t1, $t0, mini				# if i < k branch to mini
	b 		endmain						# otherwise branch to endmain

endmain:
	la		$a0, msg3					# load address of msg3 into $a0
	li		$v0, 4						# 4 is the print_string syscall
	syscall								# make the syscall to print msg3
	
	add		$t3, $sp, $t0				# $t3 = $sp + 4*k
	lw		$a0, 0($t3)					# $a0 = k
	li		$v0, 1						# 1 is the print_int syscall
	syscall								# make the syscall to print k
	
	la		$a0, msg4					# load address of msg4 into $a0
	li		$v0, 4						# 4 is the print_string syscall
	syscall								# make the syscall to print msg4

	move	$a0, $s2					# $a0 = $s2 (minimum number in the final k sized array)
	li		$v0, 1						# 1 is syscall for printint
	syscall								# make the syscall to print the kth largest number
	
	la		$a0, msg7					# load address of msg7 into $a0
	li		$v0, 4						# 4 is print_string syscall
	syscall								# make the syscall to print msg7
	
	add		$t3, $sp, $t0				# $t3 = $sp + (4*k)
	lw		$ra, 12($t3)				# restore return address
	lw		$fp, 8($t3)					# restore old frame pointer
	addu	$t0, $t0, 24				# $t0 = $t0 + 24
	add 	$sp, $sp, $t0				# pop off elements from the current stack frame by restoring stack pointer	
	jr		$ra							# return
	li		$v0, 10						# 10 is the syscall to exit
	syscall								# make the syscall to exit
	
	.data
msg:		.asciiz "Enter a positive integer k \n"
msg1:		.asciiz "Enter the count of elements to be read \n"
msg2:		.asciiz "Enter element number "
msg3:		.asciiz "The "
msg4:		.asciiz "-th largest number is: "
msg7:		.asciiz " \n"