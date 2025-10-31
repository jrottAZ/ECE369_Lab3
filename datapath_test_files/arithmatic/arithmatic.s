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

add $t2, $t1, $t0  # 69 + 1 = 70

nop

nop

nop

nop

nop

sub $t2, $t1, $t0  # 1 - 69 = -68

nop

nop

nop

nop

nop

mul $t2, $t1, $t0 # 1 * 69 = 69

nop

nop

nop

nop

nop
