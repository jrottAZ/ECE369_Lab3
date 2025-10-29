.data                   	# Put Global Data here
N:      .word 3 		# 'N' is the address which contains the loop count, 5
X:      .word -2, -4, 7 	# 'X' is the address of the 1st element in the array to be added
SUM:    .word 0			# 'SUM' is the address that stores the final sum
str:    .asciiz "The sum of the array is = " 

.text				# Put program here 
.globl main			# globally define 'main' 

main:
    nop
    nop
    lw      $s0, 0($zero)		# load loop counter from the address location 'N' and stores into register $s0 
    nop
    nop
    nop
    nop
    addi $s1, $s0, 4
    nop
    nop
    nop
    nop
    addi $s2, $s1, 5
    syscall			# this ends execution 

.end