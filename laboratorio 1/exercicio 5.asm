.data
msg: .asciiz "digite o primeiro falor\n"
res: .asciiz "O menor valor é "
cmd1: .asciiz "digite o primeiro valor\n"
cmd2: .asciiz "digite o segundo valor\n"

.text

main:

#pede pra chamar o primeiro valor
la $a0, cmd1
jal printfString
#ler
jal scanfInteger
add $s0, $0, $v0
#pede pra digitar o segundo
la $a0, cmd2
jal printfString
#ler
jal scanfInteger
add $s1, $0, $v0


#carrega os argumentos para menor
add $a0, $0, $s0
add $a1, $0, $s1

jal menor #chama o menor

add $s2, $0, $v0 #pega o retorno de menor

#printa msg de resposta
la $a0, res
jal printfString

#printa resposta
add $a0, $0, $s2
jal printfInteger

add $v0, $0, 10 #finaliza
syscall


scanfInteger: #o inteiro lido estará em em v0
addi $v0, $0, 5 #codigo pra ler inteiro
syscall
jr $ra

printfString: #a string deve estar em a0
addi $v0, $0, 4 #codigo pra printar string
syscall 
jr $ra


menor: #em a0 deverá ter o primeiro numero e em a1 o segundo, o resultado estará em v0
slt $t0, $a1, $a0

bne $t0, $0, SEGUNDO_MENOR
PRIMEIRO_MENOR:
add $v0, $0, $a0
jr $ra

SEGUNDO_MENOR:
add $v0, $0, $a1
jr $ra

printfInteger: #o numero a ser printado tem que tá no a0
addi $v0, $0, 1
syscall