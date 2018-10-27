#Calcula o fatorial de um numero utilizando a pilha

.data
    insira: .asciiz "Insira um numero: "
    resultado: .asciiz "\nO resultado eh: "
.text

.globl main
    main:
    li $v0, 4   	 #Insira um numero
    la $a0, insira
    syscall

    li $v0, 5   	 #Leitura de numero
    syscall
    
    add $a0,$zero,$v0   #O argumento da funcao eh N
    
    jal fatorial
    
    add $s0,$zero,$v0
    
    li $v0, 4   	 #O resultado eh:
    la $a0, resultado
    syscall
    	
    li $v0, 1		#Mostra o resultado
    add $a0,$s0,$zero
    syscall
    
    j Exit
    
fatorial:
	beq $a0,$zero,finalizando	#A condicao de parada da recursao
	
	addi $sp,$sp,-8			#Mande para a pilha para trocar os argumentos e chamar as funcoes recursivas abaixo
	sw $a0,4($sp)
	sw $ra,0($sp)
	
	addi $a0,$a0,-1
	jal fatorial

	lw $a0,4($sp)
	lw $ra,0($sp)
	addi $sp,$sp,8
	
	mult $a0,$v0			#A multiplicacao n*funct(n-1)
	mflo $v0			#$v0 eh o registrador de retorno
	
	jr $ra
	
finalizando:
	addi $v0,$zero,1
	
	lw $a0,4($sp)
	lw $ra,0($sp)
	addi $sp,$sp,8
	
	jr $ra
	
Exit:
