arr:	.word 1,  2,  6,  7,  15,
        3,  5,  8,  14,  16,
        4, 9, 13, 17, 22,
        10, 12, 18, 21, 23,
        11, 19, 20, 24, 25
fileX: .word 5
fileY: .word 5        
#arr = $a0
#fileX = $a1
#fileY = $a2
#windowX = $a3
#windowY = $a4
Main: 
	la $a0, arr
	lw $a1, fileX
	lw $a2, fileY
VBSME:
	#initialization
	add $t0, $t0, $0 #x = 0
	add $t1, $t1, $0 #y = 0
	add $t2, $0, $0 #dir = 0
	
	#finding xMax and yMax
	#xMax = $t3
	#yMax = $t4
	subi $t3, $a3, 1
	sub $t3, $a1, $t3
	
	subi $t4, $a4, 1
	sub $t4, $a2, $t4
	
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
	bne $t2, 1, dirfalse #go to dirfalse if dir != 1
	
	dirtrue:
		#Check that we dont hit right boundary
		#find if (x == xMax - 1) && (y != yMax - 1))
		bne $t0, $t7 notequal
		beq $t1, $t8, notequal
		
		addi $t1, $t1, 1
		add $t2, $0, $0
		addi $t5, $t5, 1
		j loop
		
		
		notequal:
		# else if (y == 0 && x != t7)
		bne $t1, $0, notequalagain
		beq $t0, $t7, notequalagain
		
		addi $t0, $t0, 1
		add $t2, $0, $0
		addi $t5, $t5, 1
		j loop
		
		
		notequalagain:
		#else
		addi $t0, $t0, 1
		addi $t1, $t1, -1
		addi $t5, $t5, 1
		j loop
		 
		
		
	dirfalse:	
		#if((x == 0) && (y != yMax - 1)
		bne $t0, $zero, checktop
		beq $t1, $t8, checktop
		addi $t1, $t1, 1
		addi $t2, $t2, 1
		addi $t5, $t5, 1
		j loop
		
		
		checktop:
		#else if((y == yMax - 1) && (x != xMax - 1))
		bne $t1, $t8, nonehit
		addi $t0, $t0, 1
		addi $t2, $t2, 1
		addi $t5, $t5, 1
		j loop
		
		nonehit:
		#else
		addi $t0, $t0, -1
		addi $t1, $t1, 1
		addi $t5, $t5, 1
		j loop
exit:
	jr $ra
	
	
	
print:
		
	