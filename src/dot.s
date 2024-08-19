.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    addi sp, sp, -8
    sw a0, 0(sp)
    sw a1, 4(sp)

    addi a0, x0, 36
    addi a1, x0, 1
    blt a2, a1, err_handle
    addi a0, x0, 37
    blt a3, a1, err_handle
    blt a4, a1, err_handle

    lw a1, 4(sp)
    lw a0, 0(sp)
    addi sp, sp, 8

    addi sp, sp, -28
    sw s0, 0(sp)
    sw a5, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)

    addi s0, x0, 0
    addi s1, x0, 0
    addi s2, x0, 0

loop_start:#s1: offset1, s2: offset2, s3: tmp,s4: a1[i], s5: a2[j]
    beqz a2, loop_end
    addi a2, a2, -1
    slli s3, s1, 2 # calc array[1]
    add s3, s3, a0
    lw s4, 0(s3)
    slli s3, s2, 2 # calc array[2]
    add s3, s3, a1
    lw s5, 0(s3) 
    mul s3, s4, s5
    add s0, s0, s3 #s0 = s0 + i*j
    add s1, s1, a3
    add s2, s2, a4
    j loop_start

loop_end:
    addi a0, s0, 0  
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw a5, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 28
    jr ra

err_handle:
    lw a1, 4(sp)
    addi sp, sp, 8
    j exit