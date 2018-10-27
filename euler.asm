.data
    resultado: .asciiz "IO resultado eh: "
    um: .float 1.0
    zero: .float 0.0
.text

.globl main
    main:
    
    l.s $f0,um
    l.s $f1,um  #f1 tera o valor da soma da serie
    addi $s5,$zero,9 	#s5 tera o valor de ate onde iterar em n
    addi $s6,$zero,1	#o N de baixo para fatorial
    j euler
    
euler:
	beq $s6,$s5,exit
	
	addi $a0,$zero,1
	add $a1,$zero,$s6
	jal fatorial
	
    	mtc1 $a0, $f2    	#inteiro a0 para f2
  	cvt.s.w $f2, $f2
  	
  	div.s $f3,$f0,$f2
  	add.s $f1,$f1,$f3
  	
  	addi $s6,$s6,1
  	
  	j euler


fatorial:	#a0 tera o valor da multiplicacao
		#a1 tera o valor do novo n
	mult $a0,$a1
	mflo $s0	#s0 tem o resultado da multiplicacao
	move $s1,$a1	
	addi $s1,$s1,-1		#s1 tem o valor de N-1
	beq $s1,$zero,finalizando
	
	move $a0,$s0
	move $a1,$s1
	j fatorial

finalizando:
	jr $ra 	#o resultado do fatorial esta em a0
	
exit:
	#o resultado esta em f1
	
    	li $v0, 4   	 #O resultado eh:
    	la $a0, resultado
    	syscall	
	
	li $v0, 2		#Mostra o resultado
	mov.s $f12,$f1
	syscall