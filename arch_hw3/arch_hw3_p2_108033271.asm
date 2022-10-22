.data

str1:		.asciiz "input x:"
str2:		.asciiz "input y:"
str3:		.asciiz "result = "
str4:		.asciiz "\n"

.text

#caller
_main:
	la $a0, str1	 # load address of string to print  (input x:)
	li $v0, 4	 # ready to print string
	syscall	         # print
	
	#scan input x
	li $v0, 5 	 #scanf
	syscall
	move $t0, $v0    #$t0 input x 
	
	la $a0, str2	 # load address of string to print (input y:)
	li $v0, 4	 # ready to print string
	syscall	         # print
	
	#scan input y
	li $v0, 5 	 #scanf
	syscall
	move $t1, $v0    #$t1 input y
	
	#-------------------------fib--------------------#
	move $a0, $t0    
	jal _fib         #after this, $s2=fib(x)
	#---------ans = re ( fib (x) , y )--------------#  
	move $a0, $s2
	move $a1, $t1
	jal _re
	
	la $a0, str3	 # load address of string to print (reslut = )
	li $v0, 4	 # ready to print string
	syscall	         # print
	
	li $v0, 1	 # ready to print int
	move $a0, $s3    # load int value to $a0
	syscall	         # print
	
	j _Exit
_fib:
	# ra, a0, s0 fib(x-1) , s1 fib(x-2)   4 in total
	addi $sp, $sp, -16
        sw $ra, 0($sp)            	# $ra = return address
        sw $a0, 4($sp)
        sw $s0, 8($sp)
        sw $s1, 12($sp)
	
	addi $t0, $zero, 0         	#$t0 = 0
	bne $a0, $t0, _else_if          # if x! = 0  jump to _else_if
	addi $s2, $zero, 0		# else  x = = 0 , return 0 to s2
	
	j _end_fib
_else_if:
	addi $t0, $zero, 1        	# $t0 = 1
	bne $a0, $t0, _else      	# if x! = 1  jump to _else
	addi $s2, $zero, 1		# else  x = = 1 , return 1  to s2
	j _end_fib
_else:					# if ( x ! = 0 and x ! = 1 ) do else
	addi $a0, $a0, -1         	# x= x -1
	jal _fib
	move $s0, $s2              	# $s0 fib(x-1) 
	
	lw $a0, 4($sp)            	# restore $a0 = (x)
	
	addi $a0, $a0, -2         	# x = x-2
	jal _fib
	move $s1, $s2		  	# $s1 fib(x-2)
	add $s2, $s0, $s1		# return ( fib(x-1)+fib(x-2) ) to s2
_end_fib:
	lw $ra, 0($sp)
        lw $a0, 4($sp)
        lw $s0, 8($sp)
        lw $s1, 12($sp)
        addi $sp, $sp, 16
        jr $ra				# jump to return address
_re:
	#  ra,  a0,  a1,  s0  re( x , y-2 ),  s1 re( x - 5 , y )    5 in total
	addi $sp, $sp, -20
	sw $ra, 0($sp)            	# $ra = return address
        sw $a0, 4($sp)
        sw $a1, 8($sp)
        sw $s0, 12($sp)
        sw $s1, 16($sp)
        
	bgtz $a1, _condition1		# if  y > 0   jump to _condition1
	addi $s3, $zero, 0		# else   y < = 0 , return 0  to s3
	j _re_end
_condition1:
	bgtz $a0, _condition2		# if  x > 0  jump to _condition2
	addi $s3, $zero, 1		#else  x < = 0 , return 1  to  s3
	j _re_end
_condition2:
	addi $a1, $a1, -2		# y = y - 2
	jal _re
	
	move $s0, $s3			# s0 = re( x, y - 2 )
	lw $a1, 8($sp)			# restore $a1 =  y
	
	addi $a0, $a0, -5		# x =  x - 5 
	jal _re
	move $s1, $s3			# s1 = re ( x - 5 , y )
	lw $a0, 4($sp)			# restore $a0  =  x
	add $s3, $s0, $s1		# s3 = re( x, y - 2 ) + re ( x - 5 , y )
_re_end:
	lw $ra, 0($sp)            	# $ra = return address
        lw $a0, 4($sp)
        lw $a1, 8($sp)
        lw $s0, 12($sp)
        lw $s1, 16($sp)
        addi $sp, $sp, 20
        jr $ra				# jump to return address
#terminated	
_Exit:
	li $v0, 10
  	syscall
