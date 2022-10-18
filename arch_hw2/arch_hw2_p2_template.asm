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
	li $v0, 5 	#scanf
	syscall
	move $t1, $v0
	
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
	
	 	 	
_start_guess:
	la $a0, str4	 # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	         # print
	
	addi $s7, $t2, 1
	
	li $v0, 1        # ready to print int
	move $a0, $s7    # load int value to $a0
	syscall	         # print
	
	la $a0, str5	 # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	         # print
	
	la $a0, str6	 # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	         # print
	
#enter the guess and then check the validation
_check_guess:
	#enter input
	
	# check input
	
	

#if the input is correct, continue the program and check the guess
#after that, jump to _fiveround to check the rounds 
_correctinput:
	#the player get the right answer,jump to _Win
	
	
	#the player's answer is bigger/smaller than the range -> update the range
	
	
#update the range	
_bigger_than_min:
	

#if the player guess a invalid number, ask the player to retry	
_incorrectinput:
	
	
#if the player win, the program can exit
_Win:
	
	
#if the player is out of round, you lose the game and the program can exit
#if the player still have chance,jump to _nextround to start a new round(from _start_guess)
_fiveround:
	

_nextround:
	
			
#terminated	
_Exit:
	li $v0, 10
  	syscall
