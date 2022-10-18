.data

PHello:   .asciiz "This is the first part of Homework 2. (Load, Store, Add, Sub)"
Pnewline: .asciiz "\n"
PA:      .asciiz "A = "
PB:      .asciiz "B = "
PC:      .asciiz "C = "
Test1:    .asciiz "A - C + B = "
Test2:    .asciiz "B + C - 15 = "

.text

# Hello! This is the first part of Homework 2 -- Basic MIPS Assembly Language Assignment.
# In this part, you have to fill the code in the region bounded by 2 hashtag lines.
# Hopefully you can enjoy assembly programming.
# =====================================================
# For grading, DO NOT modify the code here
# Print Hello Msg.
la $a0, PHello	   # load address of string to print
li $v0, 4	   # ready to print string
syscall	           # print
jal PrintNewline

# Load and save data (A and B)
li $t0, 48        # load A
sw $t0, 4($gp)    # save A
li $t1, 19       # load B
sw $t1, 8($gp)     # save B
li $t0, 123       # load C
sw $t0, 12($gp)     # save C
# =====================================================

# The following block helps you practice with the R-type instructions,
# including ADD and SUB, and also LOAD and STORE.
# Here, please read data from 4($gp), 8($gp) and 12($gp),
# store A - C + B  to 16($gp), and
# store B + C - 15 to 4($gp)
#####################################################
# @@@ write the code here









 


#####################################################

# =====================================================
# For grading, DO NOT modify the code below

# Print A
la $a0, PA	 # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
li $v0, 1        # ready to print int
move $a0, $t0    # load int value to $a0
syscall	         # print
jal PrintNewline

# Print B
la $a0, PB	 # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
li $v0, 1        # ready to print int
move $a0, $t1    # load int value to $a0
syscall	         # print
jal PrintNewline

# Print C
la $a0, PC	 # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
li $v0, 1        # ready to print int
move $a0, $t2    # load int value to $a0
syscall	         # print
jal PrintNewline

# Print A - C + B
lw $t6, 16($gp)

la $a0, Test1	 # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
li $v0, 1        # ready to print int
move $a0, $t6    # load int value to $a0
syscall	         # print
jal PrintNewline

# Print  B + C - 15
lw $t7, 4($gp)

la $a0, Test2	 # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
li $v0, 1        # ready to print int
move $a0, $t7    # load int value to $a0
syscall	         # print
j Exit           # jump to exit

#Check Memory
#jal PrintNewline
#lw $t0, 0($gp)
#lw $t1, 4($gp)
#lw $t2, 8($gp)
#lw $t3, 12($gp)
#lw $t4, 16($gp)

#li $v0, 1        # ready to print int
#move $a0, $t0    # load int value to $a0
#syscall	         # print
#jal PrintNewline

#li $v0, 1        # ready to print int
#move $a0, $t1    # load int value to $a0
#syscall	         # print
#jal PrintNewline

#li $v0, 1        # ready to print int
#move $a0, $t2    # load int value to $a0
#syscall	         # print
#jal PrintNewline

#li $v0, 1        # ready to print int
#move $a0, $t3    # load int value to $a0
#syscall	         # print
#jal PrintNewline

#li $v0, 1        # ready to print int
#move $a0, $t4    # load int value to $a0
#syscall	         # print
#j Exit

PrintNewline:
la $a0, Pnewline # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
jr $ra           # return

Exit:
# =====================================================
li $v0, 10
syscall
