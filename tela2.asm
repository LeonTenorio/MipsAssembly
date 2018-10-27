.data
	#Alguns exemplos de cores
	yellow:   .word 0xF5F62E
	white:	  .word 0xFFFFFF
	blue: 	  .word 0x2E8CF6
	orange:   .word 0xF67F2E
	black:	  .word 0x00000
	endereco: .word 0 #E interessante criar este para salvar a posicao base da tela
.text
	j main
	#No caso de teclado, funciona da mesma forma que na linha 15
	set_tela: #Inicia todos os valores para a tela
		addi $t0, $zero, 65536 #65536 = (512*512)/4 pixels
		add $t1, $t0, $zero #Adicionar a distribuição de pixels ao endereco
		lui $t1, 0x1004 #Endereco base da tela no heap, pode mudar se quiser
		jr $ra

	set_cores: #Salvar as cores em registradores
		lw $s4, white
		lw $s5, yellow
		lw $s6, blue
		lw $s7, orange
		jr $ra

	desenha:	#$a0 tera o valor do deslocamento a partir do inicio da tela
			#$a1 tera a cor do primeira barra
			#$a2 tera a cor da segunda barra
		add $t0, $zero, $t1
		add $t0,$t0,$a0
		addi $t2, $zero, 0
		#t0 eh o local que pintaremos
			#t2 eh o contador
		j s1
		s1:
			beq $t2,4,s2
			sw $a1,($t0)
			addi $t0,$t0,516
			addi $t2,$t2,1
			j s1
		s2:
			beq $t2,8,s3
			sw $a2,($t0)
			addi $t0,$t0,508
			addi $t2,$t2,1
			j s2
		s3:	
			beq $t2,12,s4
			sw $a1,($t0)
			addi $t0,$t0,-516
			addi $t2,$t2,1
			j s3
		s4:
			beq $t2,16,exit
			sw $a2,($t0)
			addi $t0,$t0,-508
			addi $t2,$t2,1
			j s4
			
		exit:
			jr $ra
				
	cima:
		lw $a1, black
		lw $a2, black
		jal desenha
		
		addi $a0,$a0,-512
		lw $a1, white
		lw $a2, yellow
		jal desenha
		j loop
	baixo:
		lw $a1, black
		lw $a2, black
		jal desenha
		
		addi $a0,$a0,512
		lw $a1, white
		lw $a2, yellow
		jal desenha
		j loop
	direita:
		lw $a1, black
		lw $a2, black
		jal desenha
		
		addi $a0,$a0,12
		lw $a1, white
		lw $a2, yellow
		jal desenha
		j loop
	esquerda:
		lw $a1, black
		lw $a2, black
		jal desenha
		
		addi $a0,$a0,-12
		lw $a1, white
		lw $a2, yellow
		jal desenha
		j loop
	loop:
		#Fara a leitura e avaliara pra que direcao ir
		
		li $t7,0xffff0000	#Va em registrador de leitura e verifica se teve entrada
		lw $t6,($t7)
		andi $t5,$t6,0x0001
		beqz $t5,loop	
		
		lw $t6,4($t7)
		beq $t6,119,cima
		beq $t6,100,direita
		beq $t6,115,baixo
		beq $t6,97,esquerda
		addi $t7,$zero,0
		j loop

	main: 
		jal set_tela
		jal set_cores
		add $a0,$zero,$zero
		lw $a1, white
		lw $a2, yellow
		jal desenha
		j loop
