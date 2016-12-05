# Primeiro Laboratório Organização e Arquitetura de Computadores 2/2016


## 1-Objetivo:
O principal objetivo desse experimento é se familiarizar com o ambiente MARS, utilizado na simulação de aplicações escritas com a linguagem assembly MIPS, através da criação de um programa que calcula a decomposição LU de uma matriz quadrada 3x3 utilizando MIPS.
####Opcional: tratar condições de undeflow e overflow.
## 2-Introdução Teórica:
MIPS (Microprocessor without interlocked pipeline) é uma arquitetura desenvolvida para processadores RISC (Reduced Instruction Set Computer), baseada em registradores chegou a ser utilizada inclusive em videogames como o Nintendo64. Para esse experimento foi utilizado o ambiente de simulação MARS.

Uma matriz m × n é uma função matemática
M : n × n− > R (1)
onde n e m representam, visualmente, as linhas e colunas da matriz respectivamente, portanto para cada par (i,j) a função retorna um número que está na linha i e coluna j. Indicamos a posição de um elemento em uma matriz A qualquer por 
A[i][j]
o elemento da matriz A que está na linha i e na coluna j de A. A ordem de uma matriz é dada pelo número de linhas multiplicado pelo número de colunas.Uma matriz que possui o numero de linhas ou colunas igual a 1 é chamada de vetor.
Uma matriz que possui o mesmo número de linhas e colunas é chamada matriz quadrada:
M : n × n− > R
é uma matriz quadrada de ordem n.
A diagonal principal de uma matriz M é a coleção das entradas M [i, i] ou seja, os elementos onde o número de linha e da coluna são iguais. No exemplo a seguir a diagonal principal é composta apenas por 1’s.
===
#Exemplo
![alt text](https://cloud.githubusercontent.com/assets/19763622/18296081/228fabaa-747d-11e6-8698-1964aa15ef52.PNG)

#Materiais e Métodos
##Materiais
|         o software MARS 4.5, uma IDE para assembly MIPS         	|
|:---------------------------------------------------------------:	|
|            um notebook da marca ASUS e modelo x550ln            	|
| a ferramenta Instruction Statitcs, fornecidapelo ambiente MARS  	|
| o software TEXMaker, utilizado para a confecção de um relatório 	|
