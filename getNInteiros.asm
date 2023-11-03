getNInteiros: #a0 o endereço base do vetor, #a1 a quantidade

	addiu $t0, $0, 0 #inicializa o contador
	
	FOR_GETINTEIROS:
	
		slt $t1, $t0, $a1
		beq $t1, $0,FIM_FOR_GETINTEIROS
		
		#syscall para ler um inteiro
		add $v0, $0, 5		
		syscall
		
		sll $t1, $t0, 2
		add $t1, $a0, $t1
		sw $v0, 0($t1)
		
		add $t0, $t0, 1 #incrementa o contador
	
	j FOR_GETINTEIROS
	
	FIM_FOR_GETINTEIROS:
		jr $ra