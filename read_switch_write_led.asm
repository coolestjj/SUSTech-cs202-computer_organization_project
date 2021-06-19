.data
	buf: .word 0x0000
.text
start:
	lui   $1,0xFFFF			
        ori   $28,$1,0xF000
        
	addi $t8,$zero,3
        sll $t8,$t8,22

switled:
	add $t9,$zero,$zero
	loop:
	addi $t9,$t9,1
	bne $t9,$t8,loop
	
	add $s0,$zero,$zero
	addi $s1,$zero,1
	addi $s2,$zero,2
	addi $s3,$zero,3
	addi $s4,$zero,4
	addi $s5,$zero,5
	addi $s6,$zero,6
	addi $s7,$zero,7
	
	lw   $a0,0xC70($28)  #switch(1-16)	
	lw   $a1,0xC72($28) #switch(17-24)
	
	srl $a1,$a1,4
	beq $a1,$s0,test1case0
	beq $a1,$s1,test1case1
	beq $a1,$s2,test1case2
	beq $a1,$s3,test1case3
	beq $a1,$s4,test1case4
	beq $a1,$s5,test1case5
	beq $a1,$s6,test1case6
	sub $a1,$a1,$s7
	sub $a1,$a1,$s1
	beq $a1,$s0,test2case0
	beq $a1,$s1,test2case1
	beq $a1,$s2,test2case2
	beq $a1,$s3,test2case3
	beq $a1,$s4,test2case4
	beq $a1,$s5,test2case5
	beq $a1,$s6,test2case6
	beq $a1,$s7,test2case7

test1case0:
	beq  $t3,$s0,statement1 #if t3 = 0,go to statement1
	addi $t5,$s0,0xAAAA #t5 = 1010 1010 1010 1010
	addi $t3,$s0,0      #t3 = 0
	sw   $t5,0xC60($28) #led(1-16)
	j switled
statement1:
	addi $t5,$s0,0x5555 #t5 = 0101 0101 0101 0101
	addi $t3,$s0,1      #t3 = 1
	sw   $t5,0xC60($28) #led(1-16)
	j switled
test1case1:
	add  $t5,$a0,$s0		#t5 = a0
	sw   $t5,0xC60($28) #led(1-16)
	j switled
test1case2:
	addi $t5,$t5,1		#t5++
	sw   $t5,0xC60($28)	#led(1-16)
	srl $a2,$t5,16
	sw   $a2,0xC62($28)
	j switled
test1case3:
	sub $t5,$t5,$s1		#t5--
	sw   $t5,0xC60($28)	#led(1-16)
	j switled
test1case4:
	sll $t5,$t5,1		#t5 switch left one
	sw  $t5,0xC60($28)	#led(1-16)
	j switled
test1case5:
	srl $t5,$t5,1		#t5 switch right logical 1
	sw  $t5,0xC60($28)	#led(1-16)
	j switled
test1case6:
	sra $t5,$t5,1		#t5 switch right arthematical 1
	sw  $t5,0xC60($28)	#led(1-16)
	j switled

test2case0:
	add $t4,$a0,$s0
	srl $t6,$t4,8    #sw15-8   $t4   y
	sll $t5,$t6,8
	sub $t4,$t4,$t5 #sw7-0   $t6   x
	j switled
test2case1:
	add $t7,$t6,$t4
	sw  $t7,0xC60($28)	#led(1-16)
	j switled
test2case2:
	sub $t7,$t6,$t4
	sw  $t7,0xC60($28)	#led(1-16)
	j switled
test2case3:
	sllv $t7,$t6,$t4
	sw  $t7,0xC60($28)	#led(1-16)
	j switled
test2case4:
	srlv $t7,$t6,$t4
	sw  $t7,0xC60($28)	#led(1-16)
	j switled
test2case5:
	slt $t3,$t6,$t4
	beq  $t3,$s0,label
	and $t7,$t7,$s0
	sw  $t7,0xC60($28)	#led(1-16)
	j switled
label:
	and $t7,$t7,$s0
	addi $t7,$t7,1
	sw  $t7,0xC60($28)	#led(1-16)
	j switled
test2case6:
	and $t7,$t4,$t6
	sw  $t7,0xC60($28)	#led(1-16)	
	j switled	
test2case7:
	xor $t7,$t4,$t6
	sw  $t7,0xC60($28)	#led(1-16)
	j switled
	
