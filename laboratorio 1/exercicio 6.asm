.data
b: .word 3, 0, 10, 2, 4, 10, 3, 7, 8, 9
text1: .asciiz "O maior valor é: "
text2: .asciiz " sua frequência é: "

.text

main:

la $a0, b
li $a1, 10

jal maior_valor

add $s1, $0, $v0

la $a0, b
li $a1, 10

add $a3, $s1, $0
jal frequencia_maior

add $s3, $0, $v0

la $a0, text1
jal printfString

add $a0,$0, $s1
jal printfInteger

la $a0, text2
jal printfString

add $a0, $0,$s3
jal printfInteger

#retorno
addi $v0, $0, 10
syscall


maior_valor: #em a0 deverá ter o vetor e em a1 seu tamanho
lw $s0, 0($a0) #carrega o primeiro número
addiu $t0, $0, 1 #inicializa o contador
addi $a1, $a1, -1

FOR:
slt $t1, $t0, $a1
beq $t1, $0, FIM_FOR

#cálculo de acesso
sll $t3, $t0, 2
add $t3, $a0, $t3
lw $t3, 0($t3) #pega o maior e carrega em t3

#verifica o maior
slt $t4, $s0, $t3 #se o maior até então for menor
beq $t4, $0, MAIOR
add $s0, $0, $t3 #coloca o novo maior em maior

MAIOR:

addiu $t0, $t0, 1 #incrementa o contador

j FOR

FIM_FOR:
add $v0, $0, $s0 #retorno
jr $ra


frequencia_maior: #em a0 tem que tá o vetor, em a1 tem que tá a quantidade e em a3 tem que tá o maior elemento
add $s0, $0, $0 #em s0 estará a frequência
add $t0, $0, $0 #inicializa o contador
addi $a1, $a1, -1

FOR_FREQ:
slt $t1, $t0, $a1
beq $t1, $0, FIM_FOR_FREQ

#cálculo de acesso
sll $t1, $t0, 2
add $t1, $a0, $t1
lw $t1, 0($t1)

#verifica se o valor carregado é igual ao maior
sub $t1, $t1, $a3
bne $t1, $0, DIFERENTE

addi $s0, $s0, 1 #incrementa a frequencia

DIFERENTE:
addi $t0, $t0, 1 #incrementa contador

j FOR_FREQ
FIM_FOR_FREQ:
add $v0, $s0, $0 #retorna o resultado
jr $ra
	

printfString: #a string deve estar em a0
addi $v0, $0, 4 #codigo pra printar string
syscall
jr $ra


printfInteger: #o numero a ser printado tem que tá no a0
addi $v0, $0, 1
syscall
jr $ra