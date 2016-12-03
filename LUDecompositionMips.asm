.data
mensagemInicial: .asciiz "Esse programa realiza decomposicao LU em qualquer matriz 3 x 3 (sem tratamento de overflow):\n\n"
promptValorLinha: .asciiz "Entre o valor da linha "
Coluna: .asciiz " Coluna "
mensagemA: .asciiz "\n\nA matriz A eh : \n"
mensagemL: .asciiz "\n\nA matriz L eh : \n"
mensagemU: .asciiz "\n\nA matriz U eh : \n"
doubleZero: .double 0.0 # Constante 0 com precisao dupla
doubleUm: .double 1.0 # Constante 1 com precisao dupla
barra: .asciiz "|"
tab: .asciiz "	"
enter: .asciiz "\n"
comma: .asciiz ","
matrizA: .space 72 # Espaco na memoria para manter a matriz A
matrizL: .space 72 # Espaco na memoria para manter a matriz L
matrizU: .space 72 # Espaco na memoria para manter a matriz U

.text
.globl main
main:
		ldc1 $f28, doubleZero # carrega em f28 constante zero precisao dupla
		ldc1 $f30,doubleUm # carrega em f30 constante um precisao dupla

		li $v0, 4
		la $a0, mensagemInicial
		syscall # Imprime na tela a mensagem inicial

		la $a1, matrizA # carrega o endereco do espaco na memoria matrizA
		jal constroiMatriz # chama procedimento constroiMatriz

		la $a1, matrizA # carrega o endereco do espaco na memoria matrizA
		la $a2, matrizL # carrega o endereco do espaco na memoria matrizL
		la $a3, matrizU # carrega o endereco do espaco na memoria matrizU
		jal LU # chama procedimento LU


		la $a1, matrizA # carrega o endereco do espaco na memoria matrizA
		la $a2, matrizL # carrega o endereco do espaco na memoria matrizL
		la $a3, matrizU # carrega o endereco do espaco na memoria matrizU
		jal printmatrixA_LU # chama procedimento printMatrizU

		li $v0, 10  # coloca 10 no registrador $v0, codigo pra sair do programa
		syscall

######################## FIM MAIN ##############################################
#################### CONSTRUCAO DA MATRIZ ######################################
		constroiMatriz:
				move $t2, $zero # contador I
				move $t3, $zero # contador J
				li $t5, 8 # prepara constante 8 para incrementar matriz.

		while:
				beq $t3, 3, break #se o numero de linhas for i entao saia do loop

		loop1:
				beq $t2, 3, loop2 # se I for igual a 3, pule para o loop2

				########### Imprime PROMPT pro usuario #####################
				li $v0, 4
				la $a0, promptValorLinha
				syscall


				li $v0, 1  # coloca 1 no registrador $v0, codigo pra imprimir inteiro
				addi $a0, $t3, 1
				syscall

				li $v0, 4 #imprime a palavra 'Coluna'
				la $a0, Coluna
				syscall

				li $v0, 1  # coloca 1 no registrador $v0, codigo pra imprimir inteiro
        # imprime um inteiro referente ao indice i (matriz[i][j])
				addi $a0, $t2, 1
				syscall

        li $v0, 4 # imprime uma linha em branco
				la $a0, enter
				syscall

        li $v0, 7 # le double  do usuario
				syscall # do

        sdc1 $f0, 0($a1) # Armazena o numero lido na memoria
				add $a1, $a1, $t5 # soma 8 no endereco da matriz pq eh double
				add $t2, $t2, 1 # i = i+1 (incrementa i)
				j loop1
		loop2:
				addi $t3, $t3, 1 #(incrementa j) j = j+1
				move $t2, $zero # atribui 0 a i ( i= 0)
				j while
				break:
				jr $ra
#########################FIM DO PROCEDIMENTO DE LEITURA #########################
		exit: # sai do loop de volta pra main
				la $a0, enter # carrega o enter em $a0
				li $v0, 4  # 4 eh o codigo pra imprimir texto
				syscall # Imprime
				jr $ra # volta pra main

		LU:
				move $t2, $zero # reseta i
				move $t3, $zero # reseta j
				move $t4, $zero # reseta k
				addi $t0, $zero, 3 #numero de linhas

				loopPrincipal_LU:
						beq $t2, 3, exit # se i = 3, sai do loop
						move $t3, $zero # reseta j

				loop1_LU:

						bge $t3, 3, continue # salta pra continue se j = 3
						blt $t3, $t2, L #salta para L se j = i

						mul $t5, $t0, $t3 # multiplica 3 por J ($t0 por $t3) e coloca em $t5 (que vai ser o indice pra percorrer o vetor)
						add $t5, $t5, $t2 # soma i a $t5
						sll $t5, $t5, 3 # multiplica $t4 por 8 e atribui a $t4
						add $t6, $a1, $t5 # adiciona $a1 e $t4 a $t5 (ficando assim o endereco da matriz + 8*i
						ldc1 $f12, 0($t6) # carrega o double no endereco $t5

						add $t7, $a2, $t5 # adiciona o $t5 (j*dimensao + i) ao endereco
						sdc1 $f12, 0($t7) # guarda no endereco $t7 o que tem em $f12
						move $t5, $zero # reseta o indice $t5
						move $t6, $zero # reseta o endereco $t6
						move $t7, $zero # reseta o endereco $t7
						### l[j][i] = a[j][i];###########

						move $t4, $zero # reseta k
						blt $t4, $t2, loop1_1 # salta para o loop1_1 se k < i

						add $t3, $t3, 1 # j++
						j loop1_LU #salta para o loop1_LU

				loop1_1:
						###l[j][k]###
						mul $t5, $t0, $t3 # multiplica 3 por J ($t0 por $t3) e coloca em $t5 (que vai ser o indice pra percorrer o vetor)
						add $t5, $t5, $t4 # soma k a $t5
						sll $t5, $t5, 3 # multiplica $t4 por 8 e atribui a $t4
						add $t6, $a2, $t5 # adiciona $a2 e $t4 a $t5 (ficando assim o endereco da matriz + 8*i
						ldc1 $f12, 0($t6) # carrega o double do endereco $t5

						move $t5, $zero # reseta o indice $t5
						move $t6, $zero # reseta o endereco $t6

						####u[k][i]####
						mul $t5, $t0, $t4 # multiplica 3 por k ($t0 por $t3) e coloca em $t5 (que vai ser o indice pra percorrer o vetor)
						add $t5, $t5, $t2 # soma i a $t5
						sll $t5, $t5, 3 # multiplica $t4 por 8 e atribui a $t4
						add $t6, $a3, $t5 # adiciona $a2 e $t4 a $t5 (ficando assim o endereco da matriz + 8*i
						ldc1 $f10, 0($t6) # carrega o double do endereco $t6 em $f10

						move $t5, $zero # reseta o indice $t5
						move $t6, $zero # reseta o indice $t5

						mul.d $f14, $f10, $f12 # $f14 = $f10 * $f12
						mul $t5, $t0, $t3 # multiplica 3 por J ($t0 por $t3) e coloca em $t5 (que vai ser o indice pra percorrer o vetor)
						add $t5, $t5, $t2 # soma i a $t5
						sll $t5, $t5, 3 # multiplica $t4 por 8 e atribui a $t4
						add $t6, $a2, $t5 # adiciona $a1 e $t4 a $t5 (ficando assim o endereco da matriz + 8*i
						ldc1 $f16, 0($t6) # carrega o double no endereco $t5
						sub.d $f16, $f16, $f14

						sdc1 $f16, 0($t6) # carrega o double $f16 no endereco $t6
						##### l[j][i] = l[j][i] - l[j][k]* u[k][i] || valor armazenado em $t6 (L[j][i])

						move $t5, $zero # reseta o indice $t5
						move $t6, $zero # reseta o indice $t5
						addi $t4, $t4, 1 # k++

						bge $t4, $t2, incJ_loop1_LU #salta para o incJ_loop1_LU se k maior ou iguai a i
						j loop1_1 # salta para o loop1_LU

				incJ_loop1_LU:
						add $t3, $t3, 1 # incrementa j
						j loop1_LU # salta para o loop1_LU

				loop2_LU:
						bge $t3, 3, fim_incrementai #salta para fim_incrementai se $t3 for igual a 3 (i=3)
						blt $t3, $t2, U1 # se j< i  vai pra U1 e faz
						beq $t3, $t2, U2 #se j = i entao u[i][j] = 1

						# l[i][i]
						mul $t5, $t0, $t2# multiplica 3 por J ($t0 por $t3) e coloca em $t5 (que vai ser o indice pra percorrer o vetor)
						add $t5, $t5, $t2 # soma i a $t5
						sll $t5, $t5, 3 # multiplica $t4 por 8 e atribui a $t4
						add $t6, $a2, $t5 # adiciona $a1 e $t4 a $t5 (ficando assim o endereco da matriz + 8*i
						ldc1 $f12, 0($t6) # carrega o double no endereco $t5

						move $t5, $zero # reseta o indice $t5
						move $t6, $zero # reseta o endereco $t6

						# a[i][j]
						mul $t5, $t0, $t2 # multiplica 3 por I ($t0 por $t2) e coloca em $t5 (que vai ser o indice pra percorrer o vetor)
						add $t5, $t5, $t3 # soma j a $t5
						sll $t5, $t5, 3 # multiplica $t4 por 8 e atribui a $t4
						add $t6, $a1, $t5 # adiciona $a1 e $t4 a $t5 (ficando assim o endereco da matriz + 8*i
						ldc1 $f10, 0($t6) # carrega o double no endereco $t5

						# store u[i][j]
						move $t7, $zero # reseta $t7
						add $t7, $a3, $t5 # adiciona o endereco de a3(matriz U) a t5
						div.d $f14, $f10, $f12 #divide o valor em $f10 por $f12 e coloca em $f14
            # u[i][j] = a[i][j] / l[i][i]; ########## essa eh a operacao final realizada e armazenada em $f14
						sdc1 $f14, 0($t7) # armazena o valor de $f14 em u[i][j]

						move $t5, $zero # reseta o indice $t5
						move $t6, $zero # reseta o endereco $t6
						move $t7, $zero # reseta o endereco $t7

						move $t4, $zero #reseta k
						blt $t4, $t2,  loop2_1 # salta para o loop loop2_1 se k<i
						addi $t3, $t3, 1 #j++
						j loop2_LU # salta para o loop loop2_LU

				loop2_1:
						#l[i][k]
						mul $t5, $t0, $t2 # multiplica 3 por i ($t0 por $t3) e coloca em $t5 (que vai ser o indice pra percorrer o vetor)
						add $t5, $t5, $t4 # soma k a $t5
						sll $t5, $t5, 3 # multiplica $t4 por 8 e atribui a $t4
						add $t6, $a2, $t5 # adiciona $a2 e $t4 a $t5 (ficando assim o endereco da matriz + 8*i
						ldc1 $f10, 0($t6) # carrega o double do endereco $t5

						move $t5, $zero # reseta o indice $t5
						move $t6, $zero # reseta o endereco $t6

						#### u[k][j]####
						mul $t5, $t0, $t4 # multiplica 3 por k ($t0 por $t3) e coloca em $t5 (que vai ser o indice pra percorrer o vetor)
						add $t5, $t5, $t3 # soma J a $t5
						sll $t5, $t5, 3 # multiplica $t4 por 8 e atribui a $t4
						add $t6, $a3, $t5 # adiciona $a2 e $t4 a $t5 (ficando assim o endereco da matriz + 8*i
						ldc1 $f12, 0($t6) # carrega o double do endereco $t6 em $f10

						move $t5, $zero # reseta o indice $t5
						move $t6, $zero # reseta o indice $t5

						#### l[i][i]####
						mul $t5, $t0, $t2 # multiplica 3 por k ($t0 por $t3) e coloca em $t5 (que vai ser o indice pra percorrer o vetor)
						add $t5, $t5, $t2 # soma J a $t5
						sll $t5, $t5, 3 # multiplica $t4 por 8 e atribui a $t4
						add $t6, $a2, $t5 # adiciona $a2 e $t4 a $t5 (ficando assim o endereco da matriz + 8*i
						ldc1 $f14, 0($t6) # carrega o double do endereco $t6 em $f10

						move $t5, $zero # reseta o indice $t5
						move $t6, $zero # reseta o indice $t5

						#### u[i][j]####
						mul $t5, $t0, $t2 # multiplica 3 por k ($t0 por $t3) e coloca em $t5 (que vai ser o indice pra percorrer o vetor)
						add $t5, $t5, $t3 # soma J a $t5
						sll $t5, $t5, 3 # multiplica $t4 por 8 e atribui a $t4
						add $t6, $a3, $t5 # adiciona $a2 e $t4 a $t5 (ficando assim o endereco da matriz + 8*i
						ldc1 $f16, 0($t6) # carrega o double do endereco $t6 em $f10

						mul.d $f18, $f10, $f12 # $f18 = $f10 * $f12
						div.d $f18, $f18, $f14 # $f18 = $f18 * $f14
						sub.d $f16, $f16, $f18 # $f16= $f16 * $f18
            ### u[i][j] = u[i][j] - ((l[i][k] * u[k][j]) / l[i][i]); valor armazenado em $f16
						sdc1 $f16, 0($t6) # armazena o valor em $f16 no endereco 0($t6) u[i][j]

						move $t5, $zero # reseta o indice $t5
						move $t6, $zero # reseta o indice $t5
						addi $t4, $t4, 1 #k++

						bge $t4, $t2, incJ_loop2_LU # se k mair ou igual a i, salte para incJ_loop2_LU
						j loop2_1 #volta para o loop loop2_1

				incJ_loop2_LU:
						add $t3, $t3, 1 #incrementa j
						j loop2_LU #volta para o loop loop2_LU

				continue:
						move $t3, $zero # reseta j
						j loop2_LU # volta para o loop loop2_LU

				fim_incrementai:
						add $t2, $t2, 1 #soma 1 em i
						j loopPrincipal_LU ##volta para o loop loopPrincipal_LU

				L:		#l[j][i] = 0
						mul $t5, $t0, $t3 # multiplica 3 por j ($t0 por $t3) e coloca em $t5 (que vai ser o indice pra percorrer o vetor)
						add $t5, $t5, $t2 # soma i a $t5
						sll $t5, $t5, 3 # multiplica $t4 por 8 e atribui a $t4
						add $t6, $a2, $t5 # adiciona $a2 e $t4 a $t5 (ficando assim o endereco da matriz + 8*i
						sdc1 $f28, 0($t6) # carrega o double do endereco $t6 em $f10
						move $t5, $zero # reseta o indice $t5
						move $t6, $zero # reseta o indice $t5
						add $t3, $t3, 1 #incrementa 1 no contador j

						j loop1_LU #volta para o loop loop1_LU

				U1:			#u[i][j] = 0;
						mul $t5, $t0, $t2 # multiplica 3 por j ($t0 por $t3) e coloca em $t5 (que vai ser o indice pra percorrer o vetor)
						add $t5, $t5, $t3 # soma i a $t5
						sll $t5, $t5, 3 # multiplica $t4 por 8 e atribui a $t4
						add $t6, $a3, $t5 # adiciona $a2 e $t4 a $t5 (ficando assim o endereco da matriz + 8*i
						sdc1 $f28, 0($t6) # carrega o double do endereco $t6 em $f10
						move $t5, $zero # reseta o indice $t5
						move $t6, $zero # reseta o indice $t5
						add $t3, $t3, 1 #incrementa 1 no contador j
						j loop2_LU #volta para o loop loop2_LU

				U2:		#l[j][i] = 1
						mul $t5, $t0, $t2 # multiplica 3 por j ($t0 por $t3) e coloca em $t5 (que vai ser o indice pra percorrer o vetor)
						add $t5, $t5, $t3 # soma i a $t5
						sll $t5, $t5, 3 # multiplica $t4 por 8 e atribui a $t4
						add $t6, $a3, $t5 # adiciona $a2 e $t4 a $t5 (ficando assim o endereco da matriz + 8*i
						sdc1 $f30, 0($t6) # carrega o double do endereco $t6 em $f10
						move $t5, $zero # reseta o indice $t5
						move $t6, $zero # reseta o indice $t5
						add $t3, $t3, 1
						j loop2_LU #volta para o loop loop2_LU

        printmatrixA_LU:
          addi $t0, $zero, 3
          move $t8, $zero #controle do branch

        branch:
          beq $t8, $zero, controleA
          beq $t8, 1, controleL
          beq $t8, 2, controleU
          beq $t8, 3, exit

        ################################### branches de controle do print ##############
        controleA: #se o controle for 0 imprime a matriz A
          move $t2, $zero # reseta i1
          move $t3, $zero # reseta j1
          move $t9, $a1 # coloca o endereco da matriz A em $t9
          addi $t8, $t8, 1 #incrementa o contador (controle)
          li $v0, 4
          la $a0, mensagemA
          syscall
          j loopPrincipalA_LU #salto pra funcao de print

        controleL: # se o controle for 1 imprime a matriz L
          move $t2, $zero # reseta i1
          move $t3, $zero # reseta j1
          move $t9, $a2 # coloca o endereco da matriz L em $t9
          addi $t8, $t8, 1 #incrementa o contador (controle)
          li $v0, 4
          la $a0, mensagemL
          syscall #Imprime L
          j loopPrincipalA_LU #salto pra funcao de print

        controleU: #se o controle for 2 imprime a matriz A
          move $t2, $zero # reseta i1
          move $t3, $zero # reseta j1
          move $t9, $a3 # coloca o endereco da matriz U em $t9
          addi $t8, $t8, 1 #incrementa o contador (controle)
          li $v0, 4
          la $a0, mensagemU
          syscall #Imprime U
          j loopPrincipalA_LU #salto pra funcao de print

        loopPrincipalA_LU: #Ciclo principal de print
          beq $t2, 3, branch # Se i for igual ao numero de linhas da matriz sai do laco
          la $a0, barra # Coloca o endereco de barra em $a0
          li $v0, 4 # 4 eh o codigo pra imprimir texto
          syscall # Printa

        loop2_PrintA_LU: # segundo loop pra printar a matrix
          la $a0, tab # coloca o endereco de tab em $a0
          li $v0, 4 # 4 eh o codigo pra imprimir texto
          syscall # Imprime na tela

          beq $t3, $t0, loop3_PrintA_LU # Se j for igual ao numero de colunas da matriz va para o terceiro ciclo
          ######## percorre o array indo de 8 em 8 bits (double tem 8 bits) ###########
          mul $t4, $t0, $t2 # multiplica 3 por i ($t0 por $t2) e coloca em $t4 (que vai ser o indice pra percorrer o vetor)
          add $t4, $t4, $t3 # soma j a t4
          sll $t4, $t4, 3 # multiplica $t4 por 8 e atribui a $t4
          add $t5, $t9, $t4 # adiciona $a1 e $t4 a $t5 (ficando assim o endereco da matriz + 8*i
          ldc1 $f12, 0($t5) # carrega o double no endereco $t5

          li $v0, 3 # 3 eh o codigo pra imprimir double na tela
          syscall # Imprime
          move $t4, $zero # reseta o indice $t4
          move $t5, $zero # reseta o endereco
          addi $t3, $t3, 1 # j++

          j loop2_PrintA_LU # pula para loop2_PrintL (recursiva) com j = j+1

        loop3_PrintA_LU: # loop3 (ciclo que incrementa i e imprime o layout)
          addi $t2, $t2, 1 # i++
          la $a0, barra # carrega 'barra' em $a0
          li $v0, 4 # 4 eh o codigo pra imprimir texto
          syscall # Imprime
          la $a0, enter # carrega o enter em $a0
          li $v0, 4  # 4 eh o codigo pra imprimir texto
          syscall # Imprime
          move $t3, $zero # atribui j = 0 para o laco interior comecar novamente
          j loopPrincipalA_LU # Pula pro laco principal com i = i + 1 e j = 0
