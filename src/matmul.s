.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    # Error checks
    addi sp, sp, -4
    sw s0, 0(sp)
    addi s0, x0, 1
    blt a1, s0, err_handle
    blt a2, s0, err_handle
    blt a4, s0, err_handle
    blt a5, s0, err_handle
    bne a2, a4, err_handle
    lw s0, 0(sp)
    addi sp, sp, 4
    # Prologue

    # a1*a2 x a4*a5 = a1*a5 ,a2=a4
    # A1[i][j]=a0+(i*j-1)*4
    # A2[i][j]=a3+(i*j-1)*4
    # A3[i][j] = \sum A1[i][k] * A2[k][j]
    # stride A1 is 1,stride A2 is a4
    # After calcing A3[i][j], A1 += a2, A2+=1

    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw t0, 16(sp)
    sw t1, 20(sp)
    sw t2, 24(sp)
    # s0 is the number of i, s1 is the number of j
    addi s0, x0, 0
    addi s1, x0, 0
    add t2, x0, a4
    # t0 is the idx
    mul t0, a1, a5
outer_loop_start:# calc A3[i][j]=A3[s0][s1] ,i=s2,j=s3
    beqz t0, outer_loop_end
    addi t0, t0, -1
    mul s2, s0, a5 # s2=i*m
    add s3, x0, s1# s3=j ,sw value, 0(s2+s3+d)
    addi a4, x0, 0
    addi t1, x0 ,0
inner_loop_start:# for(int k=0;k<a4;k++) a3[i][j]+=a1[i][k]*a2[k][j]
    beq a4, a2, inner_loop_end
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    mul s2, s0, a2 # Different Matrix size, this loop is enumerating A1 so its m is a2 instead of a5
    add s0, s2, a4 #s0=i*m+k
    mul s1, a4, a5
    add s1, s1, s3 #s1=k*m+j
    slli s0, s0, 2
    slli s1, s1, 2
    add s0, s0, a0
    add s1, s1, a3
    lw s0, 0(s0)
    lw s1, 0(s1)
    mul s0, s0, s1
    add t1, t1, s0
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 12
    addi a4, a4, 1
    j inner_loop_start
inner_loop_end:
    add a4, s2, s3
    slli a4, a4, 2
    add a4, a4, a6
    sw t1, 0(a4)
    addi s1, s1, 1
    bne s1, a5, outer_loop_start
    addi s1, x0, 0
    addi s0, s0, 1
    j outer_loop_start
outer_loop_end:
    # Epilogue
    lw t2, 24(sp)
    lw t1, 20(sp)
    lw t0, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 28
    jr ra
err_handle:
    lw s0, 0(sp)
    addi sp, sp, 4
    addi a0, x0, 38
    j exit
