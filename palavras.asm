.data

#Nao achei outra forma de controlar o tamanho da buffer para que deixasse de considerar os espacos em branco na hora de utiliza-la como endereco
#Por isso o usuario inserira duas vezes o local do arquivo para que na primeira vez o programa pegue o tamanho maximo que "file" tem
#e na segunda vez o endereco nao contenha espacos em branco
mensagem: .asciiz "Entre duas vezes com o endereco do arquivo:\n"	
mensagem2: .asciiz "Desculpe, entre de novo com o endereco do arquivo: "
if:	.asciiz "if"
ifm: 	.asciiz "IF"

while:	.asciiz "while"
whilem: 	.asciiz "WHILE"

for:	 .asciiz "for"
form: 	.asciiz "FOR"

else:	.asciiz "else"
elsem:	.asciiz "ELSE"

return:		.asciiz "return"
returnm:	.asciiz "RETURN"

int:	.asciiz "int"
intm: 	.asciiz "INT"

float:	.asciiz "float"
floatm:	.asciiz "FLOAT"

char:	.asciiz "char"
charm:	.asciiz "CHAR"

void: 	.asciiz "void"
voidm: 	.asciiz "VOID"

buffer:	
	.space	1024		# Espaco para colocar os caracteres
reader:	.asciiz	
file:
	.asciiz	# Local dos arquivos
	.word	0

.text
main:
	#Lembrete: no windows todos os "\" utilizados pelo enderecamento comum aqui devem ser duplicados. Exemplo C:\ deve ser usado como C:\\
	li $v0,54		#Leitura da buffer pela primeira vez com o tamanho maximo de 128
	la $a0,mensagem
	la $a1,file
	li $a2,128
	syscall
	
	la $a0,file
	jal strlen	#Chama a contagem de caracteres na string
	
	li $v0,54
	la $a0,mensagem2
	la $a1,file
	add $a2,$zero,$t0
	syscall

# Open File
	li	$v0, 13			#Open file
	la	$a0, file		
	add	$a1, $0, $0		
	add	$a2, $0, $0		
	syscall				
	add	$s0, $v0, $0
	
	li	$v0, 14			# Leitura do arquivo
	add	$a0, $s0, $0		# $s0 contains fd
	la	$a1, buffer		# Buffer
	li	$a2, 1024		# Leitura
	syscall

	la	$a0, buffer
	la 	$s4,0($a0)
	add $s7,$zero,$zero
	j inicia_pilha
	
strlen:
	li $t0, 0 # inicia o contador de caracteres da string com o valor de 0
	j strlen_loop
	strlen_loop:
		lbu $t1, 0($a0) # carrega caractere a partir do apontador $a0
		beqz $t1, strlen_exit # checa se o caractere nao eh nulo
		addi $a0, $a0, 1 # incrementa ponteiro
		addi $t0, $t0, 1 # incrementa contador
		j strlen_loop # continua o loop
		strlen_exit:
			jr $ra	#sai do loop voltando para aonde chamou a funcao
	
loop:	#este loop carrega uma letra do arquivo e chama as funcoes que vao verificar e se for da palavra específica adicionar 1 em seu contador
	#alem de avaliar se o contador que esta na pilha referente a essa palavra ja tem o tamanho da palavra
	lbu $t0,($a0)
	beq $t0,$0,exit 	#QUANDO CONCLUIR
	move $t1,$a0 		# $t1 EH a base da string do arquivo
	
	lw $s5,32($sp)
	beq $s5,2,escreve_if
	la $t0,if 		# $t0 EH a base da palavra if
	add $t0,$t0,$s5		#em t0 temos N deslocamento de caracteres que estao iguais a partir de if
	lb $t5,0($t0)		#Carrega um caractere da palavra if
	lb $t6,0($t1)		#Carrega um caractere do arquivo
	jal add_if
	
	lw $s5,28($sp)
	beq $s5,4,escreve_else
	la $t0,else 		# $t0 EH a base da palavra else
	add $t0,$t0,$s5		#em t0 temos N deslocamento de caracteres que estao iguais a partir de else
	lb $t5,0($t0)		#Carrega um caractere da palavra else
	lb $t6,0($t1)		#Carrega um caractere do arquivo
	jal add_else
	
	lw $s5,24($sp)
	beq $s5,3,escreve_for
	la $t0,for 		# $t0 EH a base da palavra for
	add $t0,$t0,$s5		#em t0 temos N deslocamento de caracteres que estao iguais a partir de for
	lb $t5,0($t0)		#Carrega um caractere da palavra for
	lb $t6,0($t1)		#Carrega um caractere do arquivo
	jal add_for

	lw $s5,20($sp)
	beq $s5,5,escreve_while
	la $t0,while 		# $t0 EH a base da palavra while
	add $t0,$t0,$s5		#em t0 temos N deslocamento de caracteres que estao iguais a partir de while
	lb $t5,0($t0)		#Carrega um caractere da palavra while
	lb $t6,0($t1)		#Carrega um caractere do arquivo
	jal add_while

	lw $s5,16($sp)
	beq $s5,6,escreve_return
	la $t0,return 		# $t0 EH a base da palavra return
	add $t0,$t0,$s5		#em t0 temos N deslocamento de caracteres que estao iguais a partir de return
	lb $t5,0($t0)		#Carrega um caractere da palavra return
	lb $t6,0($t1)		#Carrega um caractere do arquivo
	jal add_return

	lw $s5,12($sp)
	beq $s5,3,escreve_int
	la $t0,int 		# $t0 EH a base da palavra int
	add $t0,$t0,$s5		#em t0 temos N deslocamento de caracteres que estao iguais a partir de int
	lb $t5,0($t0)		#Carrega um caractere da palavra int
	lb $t6,0($t1)		#Carrega um caractere do arquivo
	jal add_int
	
	lw $s5,8($sp)
	beq $s5,5,escreve_float
	la $t0,float 		# $t0 EH a base da palavra float
	add $t0,$t0,$s5		#em t0 temos N deslocamento de caracteres que estao iguais a partir de float
	lb $t5,0($t0)		#Carrega um caractere da palavra float
	lb $t6,0($t1)		#Carrega um caractere do arquivo
	jal add_float
	
	lw $s5,4($sp)
	beq $s5,4,escreve_char
	la $t0,char 		# $t0 EH a base da palavra char
	add $t0,$t0,$s5		#em t0 temos N deslocamento de caracteres que estao iguais a partir de char
	lb $t5,0($t0)		#Carrega um caractere da palavra char
	lb $t6,0($t1)		#Carrega um caractere do arquivo
	jal add_char
	
	lw $s5,0($sp)
	beq $s5,4,escreve_void
	la $t0,void 		# $t0 EH a base da palavra void
	add $t0,$t0,$s5		#em t0 temos N deslocamento de caracteres que estao iguais a partir de void
	lb $t5,0($t0)		#Carrega um caractere da palavra void
	lb $t6,0($t1)		#Carrega um caractere do arquivo
	jal add_void

	addi $a0,$a0,1
	addi $s7,$s7,1
	j loop
	
#Explicando os loops das palavras que estamos comparando em sequencia de execucao
#o loop principal chama a funcao "add_<palavra>" para as 7 palavras diferentes
	#a funcao "add_<palavra>" compara se os registradores das letras que estamos comparando sao iguais
	#se nao sao iguai ela vai para a funcao "sai_<palavra> que zera o registrador da palavra na pilha e chama a funcao "ver_primeiro_<palavra>"
		#a funcao "ver_primeiro_<palavra>" verifica se o registrador que foi comparado com a proxima letra esperada (ja que nao eh a letra esperada) eh a primeira letra da palavra
			#se for a primeira letra da palavra chama a funcao "add_<palavra>"
			#se nao so volta para o "loop"
	#se "add_<palavra>" decidiu que os registradores sao iguais acrescenta-se um valor no contador da palavra na pilha e volta para a proxima execucao do "loop"
#antes de chamar a funcao "add_<palavra>" o loop principal compara se o local da pilha que esta o contador de letras da palavra esta com o valor da quantidade de letras que a palavra tem
	#se sim significa que achou a palavra inteira e precisa substituir chamando "escreve_<palavra>"

ver_primeiro_if:
	la $t0,if
	lb $t5,0($t0)
	sw $zero,32($sp)
	beq $t5,$t6,add_if
	jr $ra
sai_if:
	addi $t0,$zero,0
	sw $t0,32($sp)
	j ver_primeiro_if
add_if:
	bne $t5,$t6,sai_if
	lw $t0,32($sp)
	addi $t0,$t0,1
	sw $t0,32($sp)
	jr $ra
escreve_if:
	la $t0, ifm
	lb $t9,($t0)
	sb $t9,-2($a0)
	lb $t9,1($t0)
	sb $t9,-1($a0)
	j inicia_pilha
	
ver_primeiro_else:
	la $t0,else
	lb $t5,0($t0)
	sw $zero,28($sp)
	beq $t5,$t6,add_else
	jr $ra
sai_else:
	addi $t0,$zero,0
	sw $t0,28($sp)
	j ver_primeiro_else
add_else:
	bne $t5,$t6,sai_else
	lw $t0,28($sp)
	addi $t0,$t0,1
	sw $t0,28($sp)
	jr $ra
escreve_else:
	la $t0, elsem
	lb $t9,($t0)
	sb $t9,-4($a0)
	lb $t9,1($t0)
	sb $t9,-3($a0)
	lb $t9,2($t0)
	sb $t9,-2($a0)
	lb $t9,3($t0)
	sb $t9,-1($a0)
	j inicia_pilha
	
ver_primeiro_for:
	la $t0,for
	lb $t5,0($t0)
	sw $zero,24($sp)
	beq $t5,$t6,add_for
	jr $ra
sai_for:
	addi $t0,$zero,0
	sw $t0,24($sp)
	j ver_primeiro_for
add_for:
	bne $t5,$t6,sai_for
	lw $t0,24($sp)
	addi $t0,$t0,1
	sw $t0,24($sp)
	jr $ra
escreve_for:
	la $t0, form
	lb $t9,($t0)
	sb $t9,-3($a0)
	lb $t9,1($t0)
	sb $t9,-2($a0)
	lb $t9,2($t0)
	sb $t9,-1($a0)
	j inicia_pilha
	
ver_primeiro_while:
	la $t0,while
	lb $t5,0($t0)
	sw $zero,20($sp)
	beq $t5,$t6,add_while
	jr $ra
sai_while:
	addi $t0,$zero,0
	sw $t0,20($sp)
	j ver_primeiro_while
add_while:
	bne $t5,$t6,sai_while
	lw $t0,20($sp)
	addi $t0,$t0,1
	sw $t0,20($sp)
	jr $ra
escreve_while:
	la $t0, whilem
	lb $t9,($t0)
	sb $t9,-5($a0)
	lb $t9,1($t0)
	sb $t9,-4($a0)
	lb $t9,2($t0)
	sb $t9,-3($a0)
	lb $t9,3($t0)
	sb $t9,-2($a0)
	lb $t9,4($t0)
	sb $t9,-1($a0)
	j inicia_pilha
	
ver_primeiro_return:
	la $t0,return
	lb $t5,0($t0)
	sw $zero,16($sp)
	beq $t5,$t6,add_return
	jr $ra
sai_return:
	addi $t0,$zero,0
	sw $t0,16($sp)
	j ver_primeiro_return
add_return:
	bne $t5,$t6,sai_return
	lw $t0,16($sp)
	addi $t0,$t0,1
	sw $t0,16($sp)
	jr $ra
escreve_return:
	la $t0, returnm
	lb $t9,($t0)
	sb $t9,-6($a0)
	lb $t9,1($t0)
	sb $t9,-5($a0)
	lb $t9,2($t0)
	sb $t9,-4($a0)
	lb $t9,3($t0)
	sb $t9,-3($a0)
	lb $t9,4($t0)
	sb $t9,-2($a0)
	lb $t9,5($t0)
	sb $t9,-1($a0)
	j inicia_pilha
	
ver_primeiro_int:
	la $t0,int
	lb $t5,0($t0)
	sw $zero,12($sp)
	beq $t5,$t6,add_int
	jr $ra
sai_int:
	addi $t0,$zero,0
	sw $t0,12($sp)
	j ver_primeiro_int
add_int:
	bne $t5,$t6,sai_int
	lw $t0,12($sp)
	addi $t0,$t0,1
	sw $t0,12($sp)
	jr $ra
escreve_int:
	la $t0, intm
	lb $t9,($t0)
	sb $t9,-3($a0)
	lb $t9,1($t0)
	sb $t9,-2($a0)
	lb $t9,2($t0)
	sb $t9,-1($a0)
	j inicia_pilha	
	
ver_primeiro_float:
	la $t0,float
	lb $t5,0($t0)
	sw $zero,8($sp)
	beq $t5,$t6,add_float
	jr $ra
sai_float:
	addi $t0,$zero,0
	sw $t0,8($sp)
	j ver_primeiro_float
add_float:
	bne $t5,$t6,sai_float
	lw $t0,8($sp)
	addi $t0,$t0,1
	sw $t0,8($sp)
	jr $ra
escreve_float:
	la $t0, floatm
	lb $t9,($t0)
	sb $t9,-5($a0)
	lb $t9,1($t0)
	sb $t9,-4($a0)
	lb $t9,2($t0)
	sb $t9,-3($a0)
	lb $t9,3($t0)
	sb $t9,-2($a0)
	lb $t9,4($t0)
	sb $t9,-1($a0)
	j inicia_pilha

ver_primeiro_char:
	la $t0,char
	lb $t5,0($t0)
	sw $zero,4($sp)
	beq $t5,$t6,add_char
	jr $ra
sai_char:
	addi $t0,$zero,0
	sw $t0,4($sp)
	j ver_primeiro_char
add_char:
	bne $t5,$t6,sai_char
	lw $t0,4($sp)
	addi $t0,$t0,1
	sw $t0,4($sp)
	jr $ra
escreve_char:
	la $t0, charm
	lb $t9,($t0)
	sb $t9,-4($a0)
	lb $t9,1($t0)
	sb $t9,-3($a0)
	lb $t9,2($t0)
	sb $t9,-2($a0)
	lb $t9,3($t0)
	sb $t9,-1($a0)
	j inicia_pilha
	
ver_primeiro_void:
	la $t0,void
	lb $t5,0($t0)
	sw $zero,0($sp)
	beq $t5,$t6,add_void
	jr $ra
sai_void:
	addi $t0,$zero,0
	sw $t0,0($sp)
	j ver_primeiro_void
add_void:
	bne $t5,$t6,sai_void
	lw $t0,0($sp)
	addi $t0,$t0,1
	sw $t0,0($sp)
	jr $ra
escreve_void:
	la $t0, voidm
	lb $t9,($t0)
	sb $t9,-4($a0)
	lb $t9,1($t0)
	sb $t9,-3($a0)
	lb $t9,2($t0)
	sb $t9,-2($a0)
	lb $t9,3($t0)
	sb $t9,-1($a0)
	j inicia_pilha

inicia_pilha:	#a pilha tera os contadores dos caracteres das palavras que estamos procurando
	addi $sp,$sp,-36
	addi $t0,$zero,0
	sw $t0,32($sp)		#de IF
	sw $t0,28($sp)		#de ELSE
	sw $t0,24($sp)		#de FOR
	sw $t0,20($sp)		#de WHILE
	sw $t0,16($sp)		#de RETURN
	sw $t0,12($sp)		#de INT
	sw $t0,8($sp)		#de FLOAT
	sw $t0,4($sp)		#de CHAR
	sw $t0,0($sp)		#de VOID
	j loop
exit:
	#Abre um arquivo para salvar a saida
    	
	li	$v0, 16			# fecha o arquivo original que esta com FD em $s0
	add	$a0, $s0, $0		
	syscall	
	
        li $v0,13           
    	la $a0,file 	
	li $a1, 1           
	li $a2, 0  
    	syscall
    	move $s2,$v0        # FD de saida esta em $s2

       	li $v0, 15              # syscall para escrita nesse arquivo
    	move $a0, $s2         	# manda para $a0 o FD de saida
    	la $a1, buffer      	# escreve a string que alteramos durante toda a execucao nesse arquivo de saida
    	add $a2,$s7,$zero
    	#li $a2, 1024            # tamanho maximo do arquivo
    	syscall  
  
       	li $v0, 16      	# fecha o arquivo de saida
       	add $a0,$s2,$0
    	syscall
