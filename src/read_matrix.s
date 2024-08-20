.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    addi sp, sp, -8
        sw a1, 4(sp)
        sw a2, 0(sp)
        addi a2, x0, -1
        addi a1, x0, 0
        jal fopen
        beq a0, a2, error_fopen
        lw a1, 4(sp)
        lw a2, 0(sp)
    addi sp, sp, 8

    addi sp, sp, -4
    sw a0, 0(sp)

        addi sp, sp, -4#read a1
            sw a2, 0(sp)
            addi a2, x0, 4 
            jal fread
            beqz a0, error_fread_n
            lw a2, 0(sp)
        addi sp, sp, 4

        lw a0, 0(sp)

        addi sp, sp, -8 #read a2
            sw a1, 0(sp)
            add a1, x0, a2 # a2->a1
            sw a2, 4(sp)
            addi a2, x0, 4
            jal fread 
            lw a2, 4(sp)
            addi sp, sp, 4
            beqz a0, error_fread_m
            lw a1, 0(sp)
        addi sp, sp, 4

        addi sp, sp, -8# malloc
            sw s0, 0(sp)
            sw s1, 4(sp)

            lw s0, 0(a1)
            lw s1, 0(a2)
            mul a0, s0, s1
            slli a0, a0, 2
            jal malloc
            beqz a0, error_malloc
            sw s1, 4(sp)
            sw s0, 0(sp)
        addi sp, sp, 8

        addi sp, sp, -4
            sw t0, 0(sp)
            add t0, x0, a0
            lw a0, 4(sp)

            addi sp, sp, -8
                sw a1, 0(sp)
                sw a2, 4(sp)
                lw a1, 0(a1)
                lw a2, 0(a2)
                mul a2, a1, a2
                slli a2, a2, 2
                add a1, x0, t0
                jal fread
                beqz a0, error_fread
                lw a2, 4(sp)
                lw a1, 0(sp)
            addi sp, sp, 8

            lw a0, 4(sp)
            addi sp, sp, -4
                sw a1, 0(sp)
                addi a1, x0, -1
                jal fclose
                beq a0, a1, error_fclose
                lw a1, 0(sp)
            addi sp, sp, 4
            
            add a0, x0, t0
            sw t0, 0(sp) 
        addi sp, sp, 4
    addi sp, sp, 4

    # Epilogue
    jr ra
error_fclose:
    lw a1, 0(sp)
    addi sp, sp, 12
    addi a0, x0, 28
    j exit
error_fopen:
    lw a1, 4(sp)
    lw a2, 0(sp)
    addi sp, sp, 8
    addi a0, x0, 27
    j exit
error_fread_n:
    lw a2, 0(sp)
    addi sp, sp, 8
    addi a0, x0, 29
    j exit
error_fread_m:
    addi sp, sp, 8
    addi a0, x0, 29
    j exit
error_malloc:
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 12
    addi a0, x0, 26
    j exit
error_fread:
    lw a2, 4(sp)
    lw a1, 0(sp)
    addi sp, sp, 16
    addi a0, a0, 29
    j exit