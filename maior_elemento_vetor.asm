
maior_valor: #em a0 deverá ter o vetor e em a1 seu tamanho
lw $s0, 0($a0) #carrega o primeiro número
addiu $t0, $0, 1 #inicializa o contador
addi $a1, $a1, -1

FOR_MAIOR:
slt $t1, $t0, $a1
beq $t1, $0, FIM_FOR_MAIOR

#cálculo de acesso
sll $t3, $t0, 2
add $t3, $a0, $t3
lw $t3, 0($t3) #pega o maior e carrega em t3

#verifica o maior
slt $t4, $s0, $t3 #se o maior até então for_MAIOR menor
beq $t4, $0, MAIOR
add $s0, $0, $t3 #coloca o novo maior em maior

MAIOR:

addiu $t0, $t0, 1 #incrementa o contador

j FOR_MAIOR

FIM_FOR_MAIOR:
add $v0, $0, $s0 #retorno
jr $ra
