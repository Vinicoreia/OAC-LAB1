# Decomposição LU e suas Aplicações

Suponha que possamos escrever uma matriz **A** como o produto de duas matrizes:

                                     L.U = A



Onde **L** é *lower triangular* (composta por elementos da diagonal para baixo)
e **U** é *upper triangular* (composta por elementos da diagonal para cima),
isso para qualquer matriz quadrada. Essa técnica é usada para resolver sistemas
de equações de uma forma mais eficiente ou encontrar as matrizes inversas.

As matrizes L e U são unicas se a matriz não é singular, ou seja se seu
determinante for diferente de zero.

A decomposição LU é basicamente uma forma diferente da eliminação gaussiana e
suas aplicações variam entre resoluções de sistemas de equações lineares,
cálculo do determinante e cálculo da matriz inversa.


### Exemplo

  ![alt text](https://cloud.githubusercontent.com/assets/19763622/18297533/8d91c730-7487-11e6-97d0-e13ec772c944.PNG)

---
# Como decompor uma matriz A em LU:

Seja uma matriz **A** com M linhas e N colunas:

                                A = L.U

1. Escalonamos a matriz **A** até encontrar a matriz escalonada **U** com mesma
dimensão de A (M linhas e N colunas)
2. As colunas de **L** são encontradas durante o escalonamento de **A**, lembre-se que
somente as colunas linearmente independentes podem ser usadas.
3. Se **A** possuir mais colunas que linhas as colunas de **L** são iguais à matriz
identidade.
