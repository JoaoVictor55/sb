.data 
teste: .asciiz  "Eu fui a pRAia"
frase: .space 100
inicio: .asciiz "Digite uma frase:\n"
prompt1: .asciiz "Letra "
prompt2: .asciiz " = "
prompt3: .asciiz " vez\n"
letra: .space 2 #uma letra + 1 null


.text

main:

	la $a0, inicio
	jal printfString

	la $a0, frase
	addi $a1, $0, 100
	jal leString

	
	addi $a1, $0, 14
	jal contaFrequencia	
	
	add $s0, $0, $v0
	
	li $v0, 10	
	syscall	

contaFrequencia: #em a0 deverá tá a string e em a1 o tamanho			
	
	#a função ler um caracter da string e verifica se é uma letra minúscula ou maiúscula. Baseado nisso ela 
	#procura a posição correspondente no vetor e incrementa a frequência
	
	addi $sp, $sp, -184 #aloca o espaço na pilha	
	add $s2, $0, $a0 #guarda o inicio da string
	add $s1, $sp, $0 #guarda o inicio	
	addi $s0, $0, 0 #contador do vetor
	
	FOR_FREQ_PALAVRAS:
		slt $t0, $s0, $a1
		beq $t0, $0, FIM_FOR_FREQ_PALAVRAS
		#pega uma letra da string
		add $t0, $s2, $s0
		lb $t0, 0($t0) #pega a letra
		
		#verifica se é maiúscula ou minúscula
		#salva os dados atuais na pilha
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $t0, 4($sp)
		add $a0, $0, $t0 #move o caracter para o argumento da função
		jal ehMinusculo
		#recupera os dados salvos
		lw $t0, 4($sp)
		lw $ra, 0($sp)
		
		addi $sp, $sp, 8
		
		slt $t2, $v0, $0 #se não for caracter do alfabeto, continue
		bne $t2, $0, FREQ_CONTINUE
		
		beq $v0, $0, FREQ_MAIUSCULA #é uma letra maiúscula
		
		addi $t0, $t0, -6 #offset das minúsculas 
		
		FREQ_MAIUSCULA:		
		
		addi $t0, $t0, -65 #offset
		
		#acesso na pilha
		sll $t0, $t0, 2
		add $t0, $sp, $t0
		
		lw $t1, 0($t0)
		addi $t1, $t1, 1
		sb $t1, 0($t0)
		
		FREQ_CONTINUE:
			addi $s0, $s0, 1
			j FOR_FREQ_PALAVRAS
		
	FIM_FOR_FREQ_PALAVRAS:
		#salva os dados atuais para chamar a função que exibe as frequência
		add $v0, $s1, $0
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $a0, 4($sp)

		add $a0, $0, $s1
		jal exibeFrequencia
		
		lw $a0, 4($sp)
		lw $ra, 0($sp)

		addi $sp, $sp, 192 #desaloca pilha

		jr $ra

ehMinusculo: #verifica se um caracter é minusculo (1) ou maiusculo (0), (-1) se não for alfabético
	addi $t1, $0, 64 #antes de A 	
	addi $t2, $0, 91 #depois de Z		
	addi $t3, $0, 96 #antes de a	
	addi $t4, $0, 123 #depois de z		
	
	slt $t5, $t1, $a0 #se ele é maior ou igual a 65		
	slt $t6, $a0, $t2 #se ele é menor ou igual a 90
	
	and $t5, $t5, $t6 #é maiúsculo?		
	bne $t5, $0, MAIUSCULO
	
													
	slt $t0, $t3, $a0 #se ele é maior ou igual a 97	
	slt $t7, $a0, $t4 #se ele é menor ou igual a 122		

	and $t0, $t0, $t7 #é minúsculo
	beq $t0, $0, N_ALFABETO
				
	addi $v0, $0, 1		
	jr $ra		
	
	MAIUSCULO:
		beq $t5, $0, N_ALFABETO
		addi $v0, $0, 0		
		jr $ra
		
		N_ALFABETO:
			addi $v0, $0, -1
			jr $ra

exibeFrequencia: #em a0 deverá ter o endereço inicial do vetor que contém a frequência

	addi $t0, $0, 0 #inicializa o contador
	#addi $t4, $0, 25 #marca o inicio das minúsculas. Usado p/ cálcular offset
	FOR_EXIBE_FREQUENCIA:
		slti $t1, $t0, 51 #considera-se que o vetor vai de 0 (A) até 51 (z)
		
		beq $t1, $0, FOR_EXIBE_FREQUENCIA_FIM
		
		sll $t1, $t0, 2
		add $t1, $a0, $t1
		lw $t2, 0($t1) #t2 tem a frequência
		
		#se a frequência for 0, então não exibe
		beq $t2, $0, FIM_EXIBICAO_LETRA
		
		#verifica se é uma letra minúscula
		slti $t3, $t0, 25
		bne $t3, $0, OFFSET_MAIUSCULA
		
		#offset para minúsculas
#		addi $t5, $t0, 6
		addi $t5, $t0, 71
		
		j CONTINUE_EXIBICAO
				
		OFFSET_MAIUSCULA:
		
			addi $t5, $t0, 65
		
		CONTINUE_EXIBICAO:
		
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		
		#printa o resultado
		la $a0, prompt1
		jal printfString
		
		la $a0, letra
		sb $t5, 0($a0)
		sb $0, 1($a0)
		jal printfString
		
		la $a0, prompt2
		jal printfString
		
		add $a0, $0, $t2
		jal printfInteger
		
		la $a0, prompt3
		jal printfString
		
		lw $a0, 4($sp)
		lw $ra, 0($sp)
		
		add $sp, $sp, 8
			
		FIM_EXIBICAO_LETRA:
			addi $t0, $t0, 1
			j FOR_EXIBE_FREQUENCIA
		
	FOR_EXIBE_FREQUENCIA_FIM:
		jr $ra
		
printfString: #a string deve estar em a0
	addiu $v0, $0, 4 #codigo pra printar string
	syscall
	jr $ra


printfInteger: #o numero a ser printado tem que tá no a0
	addiu $v0, $0, 1
	syscall
	jr $ra

leString: #o endereço da string deverá estar em a0 e o tamanho em a1

	addiu $v0, $0, 8
	syscall
	jr $ra