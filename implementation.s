.data 
# Example test input for debugging
asize:  .word 4, 4, 2, 2    
frame:  .word 0, 0, 1, 2, 
        .word 0, 0, 3, 4,
        .word 0, 0, 0, 0,
        .word 0, 0, 0, 0
window: .word 1, 2, 
        .word 3, 4

space:   .asciiz " "
newline: .asciiz "\n"

.text
.globl main
main: 
    la   $a0, asize     # load address of asize
    la   $s0, frame     # frame address
    la   $s5, window    # window address

    lw   $s1, 0($a0)    # fileX = i (frame rows)
    lw   $s2, 4($a0)    # fileY = j (frame cols)
    lw   $s3, 8($a0)    # windowX = k
    lw   $s4, 12($a0)   # windowY = l

    j VBSME


# ----------------------------------------------------------------
# VBSME: Performs diagonal scan across valid frame positions
# ----------------------------------------------------------------
VBSME:
    # initialization
    add $t0, $zero, $zero   # x = 0
    add $t1, $zero, $zero   # y = 0
    li  $t2, 1              # dir = 1

    # calculate xMax = fileX - (windowX - 1)
    addi $t3, $s3, -1
    sub  $t3, $s1, $t3      # xMax = fileX - (windowX - 1)

    # calculate yMax = fileY - (windowY - 1)
    addi $t4, $s4, -1
    sub  $t4, $s2, $t4      # yMax = fileY - (windowY - 1)

    # prepare xMax - 1 and yMax - 1 for comparisons
    addi $t7, $t3, -1       # t7 = xMax - 1
    addi $t8, $t4, -1       # t8 = yMax - 1

    # i = 0
    add $t5, $zero, $zero   # loop counter i

    # total iterations = xMax * yMax
    mul $t6, $t3, $t4

    j loop


# ----------------------------
# loop: main traversal loop
# ----------------------------
loop:	
    beq $t5, $t6, exit   # if i == xMax * yMax, exit

    # access arr[y][x]
    mul $t9, $t1, $s1     # t9 = y * fileX
    add $t9, $t9, $t0     # t9 += x
    sll $t9, $t9, 2       # word offset (x4)
    add $t9, $s0, $t9     # final address
    lw  $t9, 0($t9)       # t9 = arr[y][x]

    bne $t2, 1, dirfalse  # if dir != 1, go to dirfalse

dirtrue:
    # (x == xMax - 1) && (y != yMax - 1)
    bne $t0, $t7, notequal
    beq $t1, $t8, notequal

    addi $t1, $t1, 1      # y++
    add  $t2, $zero, $zero # dir = 0
    addi $t5, $t5, 1
    jal print
    j loop

notequal:
    # (y == 0) && (x != xMax - 1)
    bne $t1, $zero, notequalagain
    beq $t0, $t7, notequalagain

    addi $t0, $t0, 1      # x++
    add  $t2, $zero, $zero # dir = 0
    addi $t5, $t5, 1
    jal print
    j loop

notequalagain:
    # x++, y--
    addi $t0, $t0, 1
    addi $t1, $t1, -1
    addi $t5, $t5, 1
    jal print
    j loop


dirfalse:
    # (x == 0) && (y != yMax - 1)
    bne $t0, $zero, checktop
    beq $t1, $t8, checktop

    addi $t1, $t1, 1      # y++
    li   $t2, 1           # dir = 1
    addi $t5, $t5, 1
    jal print
    j loop

checktop:
    # (y == yMax - 1) && (x != xMax - 1)
    bne $t1, $t8, nonehit
    beq $t0, $t7, nonehit

    addi $t0, $t0, 1      # x++
    li   $t2, 1           # dir = 1
    addi $t5, $t5, 1
    jal print
    j loop

nonehit:
    # x--, y++
    addi $t0, $t0, -1
    addi $t1, $t1, 1
    addi $t5, $t5, 1
    jal print
    j loop


exit:
    jr $ra


# -----------------------------------
# print: print value and iteration
# -----------------------------------
print:	
    # print arr[y][x] in $t9
    li $v0, 1
    move $a0, $t9
    syscall

    # print space
    li $v0, 4
    la $a0, space
    syscall

    # print iteration i
    li $v0, 1
    move $a0, $t5
    syscall

    # newline
    li $v0, 4
    la $a0, newline
    syscall

    jr $ra
