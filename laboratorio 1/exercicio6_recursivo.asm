.data
b: .word 3, 0, 10, 2, 4, 10, 3, 7, 7, 9
msg1: .asciiz "O maior elemento é: "
msg2: .asciiz " sua frequência é: "

.text

main:

	la $a0, b
	li $a1, 10
	
	jal maior_recursivo
	
	add $s0, $0, $v0
	
	la $a0, b
	li $a1, 10
	add $a3, $0, $s0
	
	jal frequencia_maior_recursivo
	
	add $s1, $0, $v0
	
	#printa os resultados
	la $a0, msg1
	jal printfString
	
	add $a0, $0, $s0
	jal printfInteger
	
	la $a0, msg2
	jal printfString
	
	add $a0, $0, $s1
	jal printfInteger
	
	#encerra
	addi $v0, $0, 10
	syscall


frequencia_maior_recursivo: #em a0 deverá tá o vetor, em $a1 o tamanho e em $a3 o maior
	
	addi $a1, $a1, -1
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal frequencia_maior_helper
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

frequencia_maior_helper:

	beq $a1, $0, FREQ_MAIOR_HELPER_BASE
	
	#prepara para a recursão
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a1, 4($sp)
	
	addi $a1, $a1, -1
	
	jal frequencia_maior_helper
	
	#calculo de acesso ao vetor
	sll $t0, $a1, 2
	add $t0, $a0, $t0
	lw $t0, 0($t0)
		
	sub $t0, $t0, $a3 #verifica se é o maior
	
	bne $t0, $0, FREQ_MAIOR_BASE_RT2
	
	addiu $v0, $v0, 1 #incrementa o retorno
	
	FREQ_MAIOR_BASE_RT2:
		lw $a1, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 8
		
		jr $ra
	
	FREQ_MAIOR_HELPER_BASE:
		#calculo de acesso ao vetor
		sll $t0, $a1, 2
		add $t0, $a0, $t0
		lw $t0, 0($t0)
		
		sub $t0, $t0, $a3 #verifica se é o maior
		addi $v0, $0, 0 #inicializa o retorno
		
		bne $t0, $0, FREQ_MAIOR_BASE_RT
		addiu $v0, $v0, 1 #incrementa o retorno
		
		FREQ_MAIOR_BASE_RT:
		lw $a1, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 8
		
		jr $ra
		
	

maior_recursivo: #em a0 deverá estar o vetor e em a1 o tamanho

	addi $a1, $a1, -1
	
	addi $sp, $sp, 4
	sw $ra, 0($sp) 
	
	jal maior_recursivo_helper
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	

maior_recursivo_helper: #em a0 deverá estar o vetor, em a1 o ultimo indice

	beq $a1, $0, RETORNO_MAIOR_HELPER
	
	#prepara para chamada recursiva
	add $sp, $sp, -8 #aloca espaço na pilha
	sw $ra, 0($sp) #guarda o endereço de retorno
	sw $a1, 4($sp) #guarda o segundo argumento

	addi $a1, $a1, -1
	jal maior_recursivo_helper #chamada recursiva
	
	#calculo de acesso
	sll $t0, $a1, 2
	add $t0, $a0, $t0
	lw $t0, 0($t0)
	
	slt $t1, $v0, $t0
	
	beq $t1, $0, PRES_MAIOR_HELPER

	add $v0, $0, $t0
	
	PRES_MAIOR_HELPER:
		
		lw $a1, 4($sp)
		lw $ra, 0($sp)
		addiu $sp, $sp, 8
		jr $ra #retorna para o caller

	RETORNO_MAIOR_HELPER:
		
		#calculo de acesso
		sll $t0, $a1, 2
		add $t0, $a0, $t0
		
		lw $v0, 0($t0) #carrega o maior até então e retorna
		
		#recarrega os elementos da pilha
		lw $a1, 4($sp)
		lw $ra, 0($sp)
		addiu $sp, $sp, 8 #desaloca
		
		jr $ra
	
	
	
printfString: #a string deve estar em a0
	addi $v0, $0, 4 #codigo pra printar string
	syscall
	jr $ra


printfInteger: #o numero a ser printado tem que tá no a0
	addi $v0, $0, 1
	syscall
	jr $ra