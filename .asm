.data
array: .word 5, 2, 9, 1, 5, 6  # Array que queremos ordenar
n: .word 6                     # Tamaño del array (número de elementos)

.text
.globl main
main:
    # Cargar el tamaño del array en $t0
    lw $t0, n                  # $t0 = número de elementos en el array

bucle_ordenar:
    # Inicializar el índice interno
    li $t1, 0                  # $t1 = índice interno del bucle para recorrer pares consecutivos

comparar:
    # Cargar dos elementos consecutivos del array
    lw $t2, array($t1)         # Cargar array[$t1] en $t2
    lw $t3, array+4($t1)       # Cargar array[$t1+1] en $t3 (siguiente elemento)

    # Comparar los dos elementos
    bge $t2, $t3, siguiente    # Si array[$t1] >= array[$t1+1], no intercambiar

    # Intercambiar los elementos
    sw $t3, array($t1)         # Guardar array[$t1+1] en array[$t1]
    sw $t2, array+4($t1)       # Guardar array[$t1] en array[$t1+1]

siguiente:
    # Avanzar al siguiente par de elementos
    addi $t1, $t1, 4           # Incrementar índice interno ($t1 += 4 bytes)

    # Calcular hasta dónde debe llegar el índice interno
    addi $t6, $t0, -1          # $t6 = límite del índice interno (n - 1)
    blt $t1, $t6, comparar     # Si $t1 < $t6, volver a comparar el siguiente par

    # Reducir el tamaño efectivo del array
    addi $t0, $t0, -1          # $t0 -= 1 porque el último elemento ya está en su lugar
    bgtz $t0, bucle_ordenar    # Si $t0 > 0, repetir el proceso para ordenar el resto del array

    # Imprimir el array ordenado
    la $t4, array              # Cargar la dirección base del array en $t4
    lw $t0, n                  # Cargar el tamaño original del array en $t0
    li $t1, 0                  # Reiniciar el índice para la impresión

imprimir:
    # Imprimir el elemento actual
    lw $a0, 0($t4)             # Cargar elemento actual en $a0
    li $v0, 1                  # Syscall para imprimir un número entero
    syscall                    # Llama al sistema para imprimir el número

    # Avanzar al siguiente elemento
    addi $t4, $t4, 4           # Avanzar 4 bytes (siguiente posición en el array)
    addi $t1, $t1, 1           # Incrementar índice para contar los elementos impresos
    blt $t1, $t0, imprimir     # Si aún no hemos llegado al final, continuar imprimiendo

    # Finalizar el programa
    li $v0, 10                 # Syscall para terminar el programa
    syscall