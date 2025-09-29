.data 
arr:	.word 1,  2,  6,  7,  15,
         3,  5,  8,  14,  16,
         4, 9, 13, 17, 22,
         10, 12, 18, 21, 23,
         11, 19, 20, 24, 25
fileX: .word 5
fileY: .word 5 
window: .word 5, 8       
#arr = $a0
#fileX = $s1
#fileY = $s2
#windowY = $s3
#windowX = $s4


# data for printing
space:   .asciiz " "
newline: .asciiz "\n"

.text
.globl Main
Main: 
	la $s0, arr
	lw $s1, fileX
	lw $s2, fileY
	li $s3, 1
	li $s4, 2
	lw $s5, window
VBSME:
	#initialization
	add $t0, $t0, $0 #x = 0
	add $t1, $t1, $0 #y = 0
	addi $t2, $0, 1 #dir = 1
	
	#finding xMax and yMax
	#xMax = $t3
	#yMax = $t4
	subi $t3, $s3, 1
	sub $t3, $s1, $t3
	
	subi $t4, $s4, 1
	sub $t4, $s2, $t4
	
	#get xMax-1 and yMax-1 before loop
	subi $t7, $t3, 1 #get xMax-1
	subi $t8, $t4, 1
	
	
	#i = $t5
	#xMax*yMax = $t6
	add $t5, $0, $0
	mul $t6, $t3, $t4
	j loop
	
	
	
	#for loop
loop:	
	beq $t5, $t6, exit   #exit when i = xMax*yMax
	#if(dir == 1)
	
	
	#calculate area of array
	mul $t9, $t1, $s1    # t9 = y * fileX
	add $t9, $t9, $t0    # + x
	sll $t9, $t9, 2      # *4 (bytes per word)
	add $t9, $s0, $t9    # base + offset
	lw  $t9, 0($t9)      # load arr[y][x] 
	
	bne $t2, 1, dirfalse #go to dirfalse if dir != 1
	dirtrue:
		#Check that we dont hit right boundary
		#find if (x == xMax - 1) && (y != yMax - 1))
		bne $t0, $t7 notequal
		beq $t1, $t8, notequal
		
		addi $t1, $t1, 1
		add $t2, $0, $0
		addi $t5, $t5, 1
		jal print
		j loop
		
		
		notequal:
		# else if (y == 0 && x != t7)
		bne $t1, $0, notequalagain
		beq $t0, $t7, notequalagain
		
		addi $t0, $t0, 1
		add $t2, $0, $0
		addi $t5, $t5, 1
		jal print
		j loop
		
		
		notequalagain:
		#else
		addi $t0, $t0, 1
		addi $t1, $t1, -1
		addi $t5, $t5, 1
		jal print
		j loop
		 
		
		
	dirfalse:	
		#if((x == 0) && (y != yMax - 1)
		bne $t0, $zero, checktop
		beq $t1, $t8, checktop
		addi $t1, $t1, 1
		addi $t2, $t2, 1
		addi $t5, $t5, 1
		jal print
		j loop
		
		
		checktop:
		#else if((y == yMax - 1) && (x != xMax - 1))
		bne $t1, $t8, nonehit
		beq $t0, $t7, nonehit
		addi $t0, $t0, 1
		addi $t2, $t2, 1
		addi $t5, $t5, 1
		jal print
		j loop
		
		nonehit:
		#else
		addi $t0, $t0, -1
		addi $t1, $t1, 1
		addi $t5, $t5, 1
		jal print
		j loop
exit:
	jr $ra
	
	
	
print:	
	# print the array value (in $t9)
    li $v0, 1
    move $a0, $t9
    syscall

    # print a space
    li $v0, 4
    la $a0, space
    syscall

    # print loop counter i ($t5)
    li $v0, 1
    move $a0, $t5
    syscall

    # print newline
    li $v0, 4
    la $a0, newline
    syscall

    jr $ra


SAD:
#filex is a0, filey is a1, windowx is s2, windowy is s3, y is s0, x is s1, arr is a3, window is a2
    addi $s6, $0, $0 #sum
    
    add $t5, $0, $0 #i
    #outer loop
    outLoop:
    	add $t6, $0, $0 #j
    	#inner loop
    	inLoop:
    	    #get the index for both the window and the grid
    	    add $t1, $s0, $t5  #gets y + i
    	    add $t2, $s1, $t6  #gets x + j
    	    mul $t9, $t1, $a0    # t9 = y new* fileX
	    add $t9, $t9, $t2    # + x new
	    sll $t9, $t9, 2      # *4 (bytes per word)
	    add $t9, $a3, $t9    # base + offset
	    lw  $t9, 0($t9)      # load arr[y+i][x+j]
	    
	    mul $t8, $t5, $s2    # t8 = i * windowX
	    add $t8, $t9, $t6    # + j
	    sll $t8, $t9, 2      # *4 (bytes per word)
	    add $t8, $a2, $t9    # base + offset
	    lw  $t8, 0($t8)      # load window[i][j]
	    
	    
    
    
    
    
    
    
    		
	
