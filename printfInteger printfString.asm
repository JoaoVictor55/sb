printfString: #a string deve estar em a0
addi $v0, $0, 4 #codigo pra printar string
syscall
jr $ra


printfInteger: #o numero a ser printado tem que tá no a0
addi $v0, $0, 1
syscall
jr $ra