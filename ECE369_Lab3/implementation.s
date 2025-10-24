# Fall 2025
# Team Members:  John Rottinghaus, Dylan Correa, Joshua Dokken
# % Effort    :   
#
# ECE369A,  
# 

########################################################################################################################
### data
########################################################################################################################
.data
# test input
# asize : dimensions of the frame [i, j] and window [k, l]
#         i: number of rows,  j: number of cols
#         k: number of rows,  l: number of cols  
# frame : frame data with i*j number of pixel values
# window: search window with k*l number of pixel values
#
# $v0 is for row / $v1 is for column

# test 0 For the 4x4 frame size and 2X2 window size
# small size for validation and debugging purpose
# The result should be 0, 2
asize0:  .word    4,  4,  2, 2    #i, j, k, l
frame0:  .word    0,  0,  1,  2, 
         .word    0,  0,  3,  4
         .word    0,  0,  0,  0
         .word    0,  0,  0,  0, 
window0: .word    1,  2, 
         .word    3,  4, 
# test 1 For the 16X16 frame size and 4X4 window size
# The result should be 12, 12
asize1:  .word    16, 16, 4, 4    #i, j, k, l
frame1:  .word    0, 1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         .word    1, 2, 3, 4, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 
         .word    2, 3, 32, 1, 2, 3, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 
         .word    3, 4, 1, 2, 3, 4, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 
         .word    0, 4, 2, 3, 4, 5, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 
         .word    0, 5, 3, 4, 5, 6, 30, 35, 40, 45, 50, 55, 60, 65, 70,  75, 
         .word    0, 6, 12, 18, 24, 30, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90, 
         .word    0, 4, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 91, 98, 105, 
         .word    0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 
         .word    0, 9, 18, 27, 36, 45, 54, 63, 72, 81, 90, 99, 108, 117, 126, 135, 
         .word    0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 
         .word    0, 11, 22, 33, 44, 55, 66, 77, 88, 99, 110, 121, 132, 143, 154, 165, 
         .word    0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120, 132, 0, 1, 2, 3, 
         .word    0, 13, 26, 39, 52, 65, 78, 91, 104, 114, 130, 143, 1, 2, 3, 4, 
         .word    0, 14, 28, 42, 56, 70, 84, 98, 112, 126, 140, 154, 2, 3, 4, 5, 
         .word    0, 15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 3, 4, 5, 6 
window1: .word    0, 1, 2, 3, 
         .word    1, 2, 3, 4, 
         .word    2, 3, 4, 5, 
         .word    3, 4, 5, 6 

# test 2 For the 16X16 frame size and a 4X8 window size
# The result should be 0, 4
asize2:  .word    16, 16, 4, 8    #i, j, k, l
frame2:  .word    7, 5, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
         .word    7, 5, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
         .word    7, 5, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
         .word    7, 5, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
         .word    0, 4, 2, 3, 4, 5, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 
         .word    0, 5, 3, 4, 5, 6, 30, 35, 40, 45, 0, 0, 0, 0, 70,  75, 
         .word    0, 6, 12, 18, 24, 30, 36, 42, 48, 54, 0, 0, 0, 0, 84, 90, 
         .word    0, 4, 8, 8, 8, 8, 42, 49, 56, 63, 0, 0, 0, 0, 98, 105, 
         .word    0, 1, 8, 8, 8, 8, 48, 56, 64, 72, 0, 0, 0, 0, 112, 120, 
         .word    0, 1, 8, 8, 8, 8, 54, 63, 72, 81, 90, 99, 108, 117, 126, 135, 
         .word    0, 10, 8, 8, 8, 8, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 
         .word    0, 11, 22, 33, 44, 55, 66, 77, 88, 99, 110, 121, 132, 143, 154, 165, 
         .word    9, 9, 9, 9, 48, 60, 72, 84, 96, 108, 120, 132, 0, 1, 2, 3, 
         .word    9, 9, 9, 9, 52, 65, 78, 91, 104, 114, 130, 143, 1, 2, 3, 4, 
         .word    9, 9, 9, 9, 56, 70, 84, 98, 112, 126, 140, 154, 2, 3, 4, 5, 
         .word    9, 9, 9, 9, 60, 75, 90, 105, 120, 135, 150, 165, 3, 4, 5, 6 
window2: .word    0, 0, 0, 0, 0, 0, 0, 0, 
         .word    0, 0, 0, 0, 0, 0, 0, 0, 
         .word    0, 0, 0, 0, 0, 0, 0, 0, 
         .word    0, 0, 0, 0, 0, 0, 0, 0


         
newline: .asciiz     "\n" 
space:   .asciiz " "



########################################################################################################################
### main
########################################################################################################################

.text

.globl main

main: 
    addi    $sp, $sp, -4    # Make space on stack
    sw      $ra, 0($sp)     # Save return address
         
    # Start test 1 
    ############################################################
    la      $a0, asize1     # 1st parameter: address of asize1[0]
    la      $a1, frame1     # 2nd parameter: address of frame1[0]
    la      $a2, window1    # 3rd parameter: address of window1[0] 
   
    jal     vbsme           # call function
    jal     print_result    # print results to console
    
    ############################################################
    # End of test 1   

   
    
                    
               
      
    lw      $ra, 0($sp)         # Restore return address
    addi    $sp, $sp, 4         # Restore stack pointer
    jr      $ra                 # Return

################### Print Result ####################################
print_result:
    # Printing $v0
    add     $a0, $v0, $zero     # Load $v0 for printing
    li      $v0, 1              # Load the system call numbers
    syscall
   
    # Print newline.
    la      $a0, newline          # Load value for printing
    li      $v0, 4                # Load the system call numbers
    syscall
   
    # Printing $v1
    add     $a0, $v1, $zero      # Load $v1 for printing
    li      $v0, 1                # Load the system call numbers
    syscall

    # Print newline.
    la      $a0, newline          # Load value for printing
    li      $v0, 4                # Load the system call numbers
    syscall
   
    # Print newline.
    la      $a0, newline          # Load value for printing
    li      $v0, 4                # Load the system call numbers
    syscall
   
    jr      $ra                   #function return

#####################################################################
### vbsme
#####################################################################


# vbsme.s 
# motion estimation is a routine in h.264 video codec that 
# takes about 80% of the execution time of the whole code
# given a frame(2d array, x and y dimensions can be any integer 
# between 16 and 64) where "frame data" is stored under "frame"  
# and a window (2d array of size 4x4, 4x8, 8x4, 8x8, 8x16, 16x8 
# or 16x16) where "window data" is stored under "window" 
# and size of "window" and "frame" arrays are stored under 
# "asize"

# - initially current sum of difference is set to a very large value
# - move "window" over the "frame" one cell at a time starting with location (0,0)
# - moves are based on the defined search pattern 
# - for each move, function calculates  the sum of absolute difference (SAD) 
#   between the window and the overlapping block on the frame.
# - if the calculated sum of difference is LESS THAN OR EQUAL to the current sum of difference
#   then the current sum of difference is updated and the coordinate of the top left corner 
#   for that matching block in the frame is recorded. 

# for example SAD of two 4x4 arrays "window" and "block" shown below is 3  
# window         block
# -------       --------
# 1 2 2 3       1 4 2 3  
# 0 0 3 2       0 0 3 2
# 0 0 0 0       0 0 0 0 
# 1 0 0 5       1 0 0 4

# program keeps track of the window position that results 
# with the minimum sum of absolute difference. 
# after scannig the whole frame
# program returns the coordinates of the block with the minimum SAD
# in $v0 (row) and $v1 (col) 


# Sample Inputs and Output shown below:
# Frame:
#
#  0   1   2   3   0   0   0   0   0   0   0   0   0   0   0   0 
#  1   2   3   4   4   5   6   7   8   9  10  11  12  13  14  15 
#  2   3  32   1   2   3  12  14  16  18  20  22  24  26  28  30 
#  3   4   1   2   3   4  18  21  24  27  30  33  36  39  42  45 
#  0   4   2   3   4   5  24  28  32  36  40  44  48  52  56  60 
#  0   5   3   4   5   6  30  35  40  45  50  55  60  65  70  75 
#  0   6  12  18  24  30  36  42  48  54  60  66  72  78  84  90 
#  0   7  14  21  28  35  42  49  56  63  70  77  84  91  98 105 
#  0   8  16  24  32  40  48  56  64  72  80  88  96 104 112 120 
#  0   9  18  27  36  45  54  63  72  81  90  99 108 117 126 135 
#  0  10  20  30  40  50  60  70  80  90 100 110 120 130 140 150 
#  0  11  22  33  44  55  66  77  88  99 110 121 132 143 154 165 
#  0  12  24  36  48  60  72  84  96 108 120 132   0   1   2   3 
#  0  13  26  39  52  65  78  91 104 117 130 143   1   2   3   4 
#  0  14  28  42  56  70  84  98 112 126 140 154   2   3   4   5 
#  0  15  30  45  60  75  90 105 120 135 150 165   3   4   5   6 

# Window:
#  0   1   2   3 
#  1   2   3   4 
#  2   3   4   5 
#  3   4   5   6 

# cord x = 12, cord y = 12 returned in $v0 and $v1 registers

.text
.globl  vbsme

# Your program must follow the required search pattern.  

# Preconditions:
#   1st parameter (a0) address of the first element of the dimension info (address of asize[0])
#   2nd parameter (a1) address of the first element of the frame array (address of frame[0][0])
#   3rd parameter (a2) address of the first element of the window array (address of window[0][0])
# Postconditions:	
#   result (v0) x coordinate of the block in the frame with the minimum SAD
#          (v1) y coordinate of the block in the frame with the minimum SAD


# Begin subroutine
vbsme:
    li      $v0, 0              # reset $v0 and $V1
    li      $v1, 0
    
    li $s2, 0x7FFFFFFF     # initialize best SAD to a large max value

    # insert your code here

    add $s0, $zero, $zero	#x
    add $s1, $zero, $zero	#y

    lw $s3, 4($a0)		#xGrid
    lw $s4, 0($a0)   		#yGrid

    lw $s5, 12($a0)   		#xWindow
    lw $s6, 8($a0)  		#yWindow

    sub $t0, $s3, $s5
    addi $t0, $t0, 1		#xMax
    
    sub $t1, $s4, $s6
    addi $t1, $t1, 1		#yMax

    add $s7, $t1, $t0
    addi $s7, $s7, -1		#max tier

    add $t2, $zero, $zero       #tier = 0

    ########################## ADD IN SAD IMPLEMENTATION HERE ################
    #set best sad to the output of this one  
	
################################################################

LOOPS:
    slt $t3, $t2, $s7           #tier < maxtier
    
    beq $t3, $zero, END

    andi $t4, $t2, 1            #check if tier is even and jump based on that
    bne $t4, $zero, DOWN
    	#going up otherwise
UP:
    add $s1, $t2, $zero		#y = tier becuase its by row
UP_LOOP:
    sub $s0, $t2, $s1		#x = tier - y
    
    #check for xMax and yMax
    bge $s0, $t0, UP_NEXT   # if x >= xMax → skip
    bge $s1, $t1, UP_NEXT   # if y >= yMax → skip
    bltz $s0, UP_NEXT       # if x < 0 → skip
    bltz $s1, UP_NEXT       # if y < 0 → skip 
    #debug here idiot lmao i am going insane
   # DEBUG1:
    #	move $a0, $s0
    #	li $v0, 1
    #	syscall
    #	la $a0, space
    #	li $v0, 4
    #	syscall
    #	move $a0, $s1
    #	li $v0, 1
    #	syscall
    #	la $a0, newline
    #	li $v0, 4
    #	syscall

    
    ########################## ADD IN SAD IMPLEMENTATION HERE ################
SAD1:
    # initialize
    li   $t9, 0          # i = 0
    li   $t8, 0          # j = 0
    li   $t7, 0          # sum = 0 (SAD)

OUTLOOP1:
    bge  $t9, $s6, EXITSAD1      # if i >= windowY → exit

    li   $t8, 0                 # reset j = 0 for each new row

INLOOP1:
    bge  $t8, $s5, NEXTROW1      # if j >= windowX → next row

    #### Calculate address for arr[y+i][x+j]
    add  $t6, $s1, $t9          # t6 = y + i
    add  $t5, $s0, $t8          # t5 = x + j
    mul  $t4, $t6, $s3          # t4 = (y + i) * fileX
    add  $t3, $t4, $t5          # t3 = (y + i) * fileX + (x + j)
    sll  $t3, $t3, 2            # byte offset (*4)
    add  $t5, $a1, $t3          # address = arr base + offset
    lw   $t6, 0($t5)            # t6 = arr[y+i][x+j]

    #### Calculate address for window[i][j]
    mul  $t4, $t9, $s5          # t4 = i * windowX
    add  $t4, $t4, $t8          # t4 = i * windowX + j
    sll  $t4, $t4, 2            # byte offset (*4)
    add  $t5, $a2, $t4          # address = window base + offset
    lw   $t3, 0($t5)            # t3 = window[i][j]

    #### diff = abs(arr - window)
    sub  $t4, $t6, $t3
    bltz $t4, NEG_DIFF1
    j    POS_DIFF1

NEG_DIFF1:
    sub  $t4, $zero, $t4
POS_DIFF1:

    #### sum += diff
    add  $t7, $t7, $t4

    addi $t8, $t8, 1            # j++
    j    INLOOP1

NEXTROW1:
    addi $t9, $t9, 1            # i++
    j    OUTLOOP1

EXITSAD1:
    #### Compare to best SAD (stored in $s2)
    blt  $t7, $s2, UPDATEBEST1
    beq $t7, $s2, UPDATEBEST1
    j	 UP_NEXT                    # return if not better

UPDATEBEST1:
    move $s2, $t7               # update best SAD = current SAD
    move $v0, $s1               # store Y coordinate of best match
    move $v1, $s0               # store X coordinate of best match
################################################################

UP_NEXT:
    addi $s1, $s1, -1
    bgez $s1, UP_LOOP
    j ENDDIRECT
DOWN:
    add $s1, $zero, $zero	#y = 0
DOWN_LOOP:
    sub $s0, $t2, $s1		#x = tier - y
    
    #check for out of bounds
    bge $s0, $t0, DOWN_NEXT   # if x >= xMax → skip
    bge $s1, $t1, DOWN_NEXT   # if y >= yMax → skip
    bltz $s0, DOWN_NEXT       # if x < 0 → skip
    bltz $s1, DOWN_NEXT       # if y < 0 → skip
    #debug here idiot lmao i am going insane
   # DEBUG2:
    #	move $a0, $s0
    #	li $v0, 1
    #	syscall
    #	la $a0, space
    #	li $v0, 4
    #	syscall
    #	move $a0, $s1
    #	li $v0, 1
    #	syscall
    #	la $a0, newline
    #	li $v0, 4
    #	syscall

    ########################## ADD IN SAD IMPLEMENTATION HERE ################
SAD2:
    # initialize
    li   $t9, 0          # i = 0
    li   $t8, 0          # j = 0
    li   $t7, 0          # sum = 0 (SAD)

OUTLOOP2:
    bge  $t9, $s6, EXITSAD2      # if i >= windowY → exit

    li   $t8, 0                 # reset j = 0 for each new row

INLOOP2:
    bge  $t8, $s5, NEXTROW2      # if j >= windowX → next row

    #### Calculate address for arr[y+i][x+j]
    add  $t6, $s1, $t9          # t6 = y + i
    add  $t5, $s0, $t8          # t5 = x + j
    mul  $t4, $t6, $s3          # t4 = (y + i) * fileX
    add  $t3, $t4, $t5          # t3 = (y + i) * fileX + (x + j)
    sll  $t3, $t3, 2            # byte offset (*4)
    add  $t5, $a1, $t3          # address = arr base + offset
    lw   $t6, 0($t5)            # t6 = arr[y+i][x+j]

    #### Calculate address for window[i][j]
    mul  $t4, $t9, $s5          # t4 = i * windowX
    add  $t4, $t4, $t8          # t4 = i * windowX + j
    sll  $t4, $t4, 2            # byte offset (*4)
    add  $t5, $a2, $t4          # address = window base + offset
    lw   $t3, 0($t5)            # t3 = window[i][j]

    #### diff = abs(arr - window)
    sub  $t4, $t6, $t3
    bltz $t4, NEG_DIFF2
    j    POS_DIFF2

NEG_DIFF2:
    sub  $t4, $zero, $t4
POS_DIFF2:

    #### sum += diff
    add  $t7, $t7, $t4

    addi $t8, $t8, 1            # j++
    j    INLOOP2

NEXTROW2:
    addi $t9, $t9, 1            # i++
    j    OUTLOOP2

EXITSAD2:
    #### Compare to best SAD (stored in $s2)
    blt  $t7, $s2, UPDATEBEST2
        beq $t7, $s2, UPDATEBEST2
    j    DOWN_NEXT                   # return if not better

UPDATEBEST2:
    move $s2, $t7               # update best SAD = current SAD
    move $v0, $s1               # store Y coordinate of best match
    move $v1, $s0               # store X coordinate of best match
################################################################
DOWN_NEXT:
    addi $s1, $s1, 1
    ble $s1, $t2, DOWN_LOOP
#loop again through outer loop increasing tier
ENDDIRECT:
    addi $t2, $t2, 1
    j LOOPS

END:

    jr $ra
