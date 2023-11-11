.data 
prompt: .asciiz "mdc("
prompt2: .asciiz ","
prompt3: .asciiz ") = "
prompt4: .asciiz "\n"
.text

main:

	jal scanfInteger
	add $a0, $0, $v0
	add $s0, $0, $a0

	jal scanfInteger
	add $a1, $0, $v0	
	add $s1, $0, $a1
	
	jal gcd
	add $t0, $0, $v0
	
	#printando os resultados:
	la $a0, prompt
	jal printfString
	
	add $a0, $0, $s0
	jal printfInteger	
		
	la $a0, prompt2
	jal printfString
	
	add $a0, $0, $s1
	jal printfInteger
	
	la $a0, prompt3	
	jal printfString
	
	add $a0, $0, $s1
	jal printfInteger
	
	la $a0, prompt4
	jal printfString
		
	addi $v0, $0, 10
	syscall


gcd:

	#aloca espaço na pilha pra chamada recursiva
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)


	#if (j == 0)
	
	beq $a1, $0,RETURN_GCD
		
	#pega a resto
	div $a0, $a1
	mfhi $t0
	
	add $a0, $0, $a1
	add $a1, $0, $t0
	
	
	jal gcd
	
	lw $a1, 8($sp)
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	
	addi $sp, $sp, 12
	
	jr $ra
	
	RETURN_GCD:
		
		add $v0, $0, $a0
		
		lw $a1, 8($sp)
		lw $a0, 4($sp)
		
		
		addi $sp, $sp, 12
		
		jr $ra

scanfInteger: #o inteiro lido estará em em v0
	addi $v0, $0, 5 #codigo pra ler inteiro
	syscall
	jr $ra


printfString: #a string deve estar em a0
	addi $v0, $0, 4 #codigo pra printar string
	syscall
	jr $ra		

printfInteger: #o numero a ser printado tem que tá no a0
	addi $v0, $0, 1
	syscall
	jr $ra

resto: 
	div $a0, $a1
	mfhi $v0	
