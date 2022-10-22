.data

str1:		.asciiz "input x:"
str2:		.asciiz "input y:"
str3:		.asciiz "input z:"
str4:		.asciiz "result = "
str5:		.asciiz "\n"

.text


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
	
	la $a0, str3	 # load address of string to print (input z:)
	li $v0, 4	 # ready to print string
	syscall	         # print
	
	#scan input z
	li $v0, 5 	 #scanf
	syscall
	move $t2, $v0    #$t2 input z
	
	#--------------fun1--------------------------------------#compare(x,y)
	move $a0, $t0    
	move $a1, $t1
	jal _compare     #after this, $s0 = compare(x,y)
	
	#-----------fun2-----------------------------------------#smod(compare(x,y),z)
	move $a0, $s0 
	move $a1, $t2 
	jal _smod
	#---------------------------------------------------------------------------#
	la $a0, str4	 # load address of string to print (reslut = )
	li $v0, 4	 # ready to print string
	syscall	         # print
	
	li $v0, 1	 # ready to print int
	move $a0, $s2    # load int value to $a0
	syscall	         # print
	
	j _Exit
	
_compare:
	# ra, a0, a1  3 in total
	addi $sp, $sp, -12
	sw $ra, 0($sp)            	# $ra = return to main address
        sw $a0, 4($sp)
	sw $a1, 8($sp)
	
	blt $a0, $a1, _compare_ture     #branch to label if ( p < q )
	move $s0, $a0			#return p
	j _compare_end
_compare_ture:
	add $s0, $a0, $a1		#return p+q
_compare_end:
	lw $ra, 0($sp)           	
        lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	jr $ra                    	# back to main
	
_smod:
	# ra, a0, a1,s0 = div , s1 = divd   5 in total
	addi $sp, $sp, -20
	sw $ra, 0($sp)           	# $ra = return to main address
        sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	
	addi $t0, $zero, 0              #loop time = $t0
	addi $s0, $zero, 1		# first let initial div $s0 = 1
	bgt $a0, $a1, _smod_ture        # if p > q  jump to _smod_ture
	rem $t1, $a1, 4                 # $t1  =  q % 4
	jal _loop                       # jump to _loop to computer  pow ( 2 , q % 4 ) 
	mul $t1, $a0, 4			# $t1 = p*4
	add $s1, $t1, $a1		# divd $s1 = $t1 + q
	rem $s2, $s1, $s0		# ans $s2 =  divd % div
	j _smod_end 
_smod_ture:
	rem $t1, $a0, 4                 #$t1 = p%4
	jal _loop			# jump to _loop to computer  pow ( 2 , p % 4 ) 
	mul $t1, $a0, 4			# $t1 = p*4
	add $s1, $t1, $a1		# divd $s1 = $t1 + q
	rem $s2, $s1, $s0               # ans $s2 = divd % div
_smod_end:				
	lw $ra, 0($sp)            	# $ra = return to main address
        lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	addi $sp, $sp, 20
	jr $ra                           # back to main
	
#------------------use loop to accomplish operation of power---------------------#
_loop:
	beq $t1, $t0, _loop_end		#if loop time = $t1  jump to _loop_end
	addi $t0, $t0, 1                #loop time = $t3
	mul $s0, $s0, 2                 #$s0 = $s0 * 2
	j _loop
	
_loop_end:
	jr $ra           #back to _smod or _smod_ture
#terminated	
_Exit:
	li $v0, 10
  	syscall
