.data

test_array: .word 6, 8, 3, 4, 0, 0, 0

.text

.global main

loop:	addi $t0, $zero, 69

nop

nop

nop

nop

nop

addi $t1, $zero 1  

nop

nop

nop

nop

nop

lw $t2, 0($t1) # save mem[1] @ $t2 

nop

nop

nop

nop

nop

sw $t2, 0($t0) # save 1 @ mem[69]

nop

nop

nop

nop

nop

sb $t2, 0($t1)

nop

nop

nop

nop

nop

lh $t2, 0($t0)

nop

nop

nop

nop

nop

lb $t2, 0($t0)

nop

nop

nop

nop

nop

sh $t0, 0($t1)

nop

nop

nop

nop

nop