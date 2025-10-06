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
    la   $a1, frame     # frame address
    la   $a2, window    # window address

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

    jal SAD                 #get initial SAD           
    add $s6, $zero, $s5
    add $v0, $t0, $zero
    add $v1, $t1, $zero

    j loop


# ----------------------------
# loop: main traversal loop
# ----------------------------
loop:
    jal SAD
    slt $s7, $s5, $s6           #check for lowest SAD
    beq $s7, $zero, skipChange
    add $s6, $s5, $zero         #replace with new lowest SAD
    add $v0, $t0, $zero
    add $v1, $t1, $zero

skipChange:


    beq $t5, $t6, exit   # if i == xMax * yMax, exit

    # access arr[y][x]
    mul $t9, $t1, $s1     # t9 = y * fileX
    add $t9, $t9, $t0     # t9 += x
    sll $t9, $t9, 2       # word offset (x4)
    add $t9, $a1, $t9     # final address
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

# ------------------------------------------------------------
# SAD: calculates the sum of absolute difference for an index
# ------------------------------------------------------------       

SAD:
    addi $sp, $sp, -40        # make stack space
    sw $t0, 36($sp)           # save temps
    sw $t1, 32($sp)
    sw $t2, 28($sp)
    sw $t3, 24($sp)
    sw $t4, 20($sp)
    sw $t5, 16($sp)
    sw $t6, 12($sp)
    sw $t7, 8($sp)
    sw $t8, 4($sp)
    sw $t9, 0($sp)    
    
    add $s5, $zero, $zero     # sum = 0

    add $t7, $t0, $zero       # i = x

sadL1:
    slt $t2, $t7, $s3         # i < windowX ?
    beq $t2, $zero, sadOutExit

    add $t8, $zero, $t1       # j = y

sadL2:
    slt $t3, $t8, $s4         # j < windowY ?
    beq $t3, $zero, sadInExit

    # load grid value: frame[(y+j)*fileX + (x+i)]
    mul $t9, $t8, $s1         # j * fileX
    add $t9, $t9, $t7         # + i
    sll $t9, $t9, 2           # word offset
    add $t9, $t9, $a1         # + frame base
    lw  $t4, 0($t9)           # grid value

    # load window value: window[j*windowX + i]
    mul $t9, $t8, $s3         # j * windowX
    add $t9, $t9, $t7         # + i
    sll $t9, $t9, 2           # word offset
    add $t9, $t9, $a2         # + window base
    lw  $t5, 0($t9)           # window value

    # absolute difference
    sub $t6, $t4, $t5
    bltz $t6, sadNeg
    j sadAdd

sadNeg:
    sub $t6, $zero, $t6       # negate if negative

sadAdd:
    add $s5, $s5, $t6         # sum += diff

    addi $t8, $t8, 1          # j++
    j sadL2

sadInExit:
    addi $t7, $t7, 1          # i++
    j sadL1

sadOutExit:
    lw $t0, 36($sp)           # restore temps
    lw $t1, 32($sp)
    lw $t2, 28($sp)
    lw $t3, 24($sp)
    lw $t4, 20($sp)
    lw $t5, 16($sp)
    lw $t6, 12($sp)
    lw $t7, 8($sp)
    lw $t8, 4($sp)
    lw $t9, 0($sp)
    addi $sp, $sp, 40

    jr $ra