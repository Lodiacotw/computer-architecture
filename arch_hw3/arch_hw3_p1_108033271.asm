.data

str1:		.asciiz "input x:"
str2:		.asciiz "input y:"
str3:		.asciiz "input z:"
str4:		.asciiz "result ="
str5:		.asciiz "\n"

.text


_main:
	la $a0, str1	 # load address of string to print  (input x:)
	li $v0, 4	 # ready to print string
	syscall	         # print
	
	#scan input x
	li $v0, 5 	 #scanf
	syscall
	move $a0, $v0    #$a0 input x 
	
	la $a0, str2	 # load address of string to print (input y:)
	li $v0, 4	 # ready to print string
	syscall	         # print
	
	#scan input y
	li $v0, 5 	 #scanf
	syscall
	move $a1, $v0    #$a0 input y
	
	la $a0, str3	 # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	         # print
	
	#scan input z
	li $v0, 5 	 #scanf
	syscall
	move $a2, $v0    #$a0 input z
	
	jal _compare
	
	la $a0, str4	 # load address of string to print (reslut = )
	li $v0, 4	 # ready to print string
	syscall	         # print
	
	li $v0, 1	 # ready to print int
	move $a0, $t2    # load int value to $a0
	syscall	         # print
	
	j _Exit
	
_compare:
	blt $a0, $a1, _compare_ture
	move $t6, $a0
	j _smod
	
_compare_ture:
	add $t6, $a0, $a1
	j _smod
	
_smod:
	
	
_smod_ture:
	

#terminated	
_Exit:
	li $v0, 10
  	syscall
