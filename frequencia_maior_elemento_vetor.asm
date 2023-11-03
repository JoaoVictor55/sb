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