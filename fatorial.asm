#Calcula o fatorial de um numero sem utilizar a pilha

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
    add $s0,$zero,$v0   	 #$s0 = n
    addi $s1,$s0,-1   		 #s1 = n-1
    
    move $a0,$s0
    move $a1,$s1
    
    bne $s1,$zero,fatorial
    j finalizando
    
    
fatorial:	#a0 tera o valor da multiplicacao
		#a1 tera o valor do novo n
	mult $a0,$a1
	mflo $s0	#s0 tem o resultado da multiplicacao	
	addi $s1,$a1,-1		#s1 tem o valor de N-1
	beq $s1,$zero,finalizando
	
	move $a0,$s0
	move $a1,$s1
	j fatorial

finalizando:
	move $s0,$a0
	
    	li $v0, 4   	 #O resultado eh:
    	la $a0, resultado
    	syscall	
	
	li $v0, 1		#Mostra o resultado
	add $a0,$s0,$zero
	syscall
Exit:
