#Reproduz a musica.asm com pausas

.include "musica.asm"
.data
	.align 0
.text
.globl main
	main:
	
	li $a1, 1000 	#Duracao em milisegundos da reproducao
	li $a2, 1 	#Instrumento
	li $a3, 127	#Volume maximo
	
	la $s7, musica
	
	j Reproducao
	Reproducao:
		
		li $v0, 32	#Sleeep
		li $a0, 500
		syscall
		
		lb $a0, 0($s7)	#Manda para reprocao a musica no local q a instrucao esta
		li $v0, 31
		syscall

		lb $s0, 0($s7)
		addi $t0, $zero, -1
		addi $s7,$s7,1
		bne $t0,$s0, Reproducao
		j Exit
		
Exit:
	li $v0,10
	syscall
