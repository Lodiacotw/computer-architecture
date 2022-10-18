.data

str1:		.asciiz "Please enter the range:\n"
str2:		.asciiz "The range is 0 to "
str3:		.asciiz "\n"
str4:		.asciiz "Round "
str5:		.asciiz " start...\n"
str6:		.asciiz "Please guess a number:\n"
str7:		.asciiz "You are out of range! Guess again! \n"
str8:		.asciiz "You win!\n"
str9:		.asciiz "You should guess from "
str10:		.asciiz " to "
str11:		.asciiz "You lose haha! The answer is "

.text

#########DONOT MODIFY HERE###########
#Setup initial 
addi $t0, $zero, 0	# minimun range
addi $t2, $zero, 0	# round
########################################## 

######How to generate random number?######## 
#addi $a1, $zero, 10	# int range [0, 10)
#addi $v0, $zero, 42	#syscall for generating random int into $a0
#syscall
#move $t3, $a0 
##########################################


#Game start!
main:

#Enter the range
_range:
	la $a0, str1	 # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	         # print
	
	#scan the range
	li $v0, 5 	 #scanf
	syscall
	move $t1, $v0    #$t1 max range 
	
	la $a0, str2	 # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	         # print
	
	li $v0, 1        # ready to print int
	move $a0, $t1    # load int value to $a0
	syscall	         # print
	
	la $a0, str3	 # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	         # print
	
#Randomly generate the answer
_generate_answer:
	addi $a1, $t1, 1	# int range [0, $t1}
	addi $v0, $zero, 42     #syscall for generating random int into $a0
	syscall 
	move $t3, $a0           #$t3 is random answer
	
_start_guess:
	la $a0, str4	       # load address of string to print
	li $v0, 4	       # ready to print string
	syscall	               # print
	
	addi $s7, $t2, 1       #round record
	
	li $v0, 1              # ready to print int
	move $a0, $s7          # load int value to $a0
	syscall	               # print
	
	la $a0, str5	       # load address of string to print
	li $v0, 4	       # ready to print string
	syscall	               # print
	
	la $a0, str6	       # load address of string to print
	li $v0, 4	       # ready to print string
	syscall	               # print
	
	j _nextround
#enter the guess and then check the validation
_check_guess:
	#enter input
	li $v0, 5
	syscall
	move $s0, $v0                #put input to $s0
	# check input
	slt $t4, $t1, $s0            #if  $t1 max range  <  $s0 input  ,$t4=1, else $t4=0  ,  input cannot bigger than max range ( input <= max range)
	slt $t5, $s0, $t0            # if  $s0 input  <  $t0 min range  ,$t5=1, else $t5=0  ,  input cannot smaller than min range (min range<= input )
	beq $t4, $t5, _correctinput  #so if input is correct $t4 ,$t5 = 0
	j _incorrectinput

#if the input is correct, continue the program and check the guess
#after that, jump to _fiveround to check the rounds 
_correctinput:
	#the player get the right answer,jump to _Win
	beq $s0, $t3, _Win          #if  input $s0 = $t3 random answer  jump to _Win
	beq $t2, $t7, _fiveround    #if round = 5 not win jump to _fiveround
	#the player's answer is bigger/smaller than the range -> update the range
	slt $t4, $t3, $s0           # if  answer $t3  <  $s0 input  ,$t4=1
	beq $t4, $zero, _bigger_than_min
	
	#modify the max range number
	la $a0, str9                # load address of string to print
	li $v0, 4                   # ready to print string
	syscall                     # print
	
	li $v0, 1                   # ready to print int
	move $a0, $t0               # load int value to $a0
	syscall                     # print
	
	la $a0, str10               # load address of string to print
	li $v0, 4                   # ready to print string
	syscall                     # print
	
	addi $t1, $s0, -1           #let max range number  =  input -1
	
	li $v0, 1                   # ready to print int
	move $a0, $t1               # load int value to $a0
	syscall                     # print
	
	la $a0, str3	            # load address of string to print
	li $v0, 4	            # ready to print string
	syscall	                    # print
	
	j _start_guess
#update the range	
_bigger_than_min:
	#modify min range number
	la $a0, str9                # load address of string to print
	li $v0, 4                   # ready to print string
	syscall                     # print
	
	addi $t0, $s0, 1            #let min range number =  input +1
	
	li $v0, 1                   # ready to print int
	move $a0, $t0               # load int value to $a0
	syscall                     # print
	
	la $a0, str10               # load address of string to print
	li $v0, 4                   # ready to print string
	syscall                     # print
	
	li $v0, 1                   # ready to print int
	move $a0, $t1               # load int value to $a0
	syscall                     # print
	
	la $a0, str3	            # load address of string to print
	li $v0, 4	            # ready to print string
	syscall	                    # print
	
	j _start_guess
#if the player guess a invalid number, ask the player to retry	
_incorrectinput:
	la $a0, str7                # load address of string to print
	li $v0, 4                   # ready to print string
	syscall                     # print
	
	j _check_guess
#if the player win, the program can exit
_Win:
	la $a0, str8                # load address of string to print
	li $v0, 4                   # ready to print string
	syscall                     # print
	j _Exit                     #jump to Exit
#if the player is out of round, you lose the game and the program can exit
#if the player still have chance,jump to _nextround to start a new round(from _start_guess)
_fiveround:
	la $a0, str11               # load address of string to print
	li $v0, 4                   # ready to print string
	syscall                     # print
	
	li $v0, 1                   # ready to print int
	move $a0,$t3                # load int value to $a0
	syscall                     # print
	
	j _Exit #jump to Exit

_nextround:
	addi $t7, $zero, 5         #set a number=5 
	addi $t2, $t2, 1           # round + 1
	j _check_guess
			
#terminated	
_Exit:
	li $v0, 10
  	syscall
