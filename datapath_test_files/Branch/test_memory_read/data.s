.data 
test_array: .word 0x7FFFFFF6, 0x7FFFFFF6, 0x7FFFFFF2, 0x7FFFFFF1 
.text 
.global main 
loop: addi $t0, $zero, $zero
nop
nop
nop
nop
nop
addi $t4, $zero, $zero
nop
nop
nop
nop
nop
lw $t1, 0($t0)
nop
nop
nop 
nop
nop
lw $t2, 4($t0) # save mem[1] @ $t2
nop
nop
nop
nop
nop
lw $t3, 8($t0) # save 1 @ mem[69]
nop
nop
nop
nop
nop
lb $t4, 1($t0)
nop
nop
nop
nop
nop
lh $t4, 2($t0)
nop
nop
nop
nop
nop
lb $t1, 11($t0)
nop
nop
nop
nop
nop
lb $t4, 6($t0)
nop
nop
nop
nop
nop