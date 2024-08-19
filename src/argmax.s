.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 36.
# =================================================================
argmax:
    # Prologue
loop_start:
    addi sp, sp, -8
    sw a0, 0(sp)
    sw s0, 4(sp)
    addi s0, x0, 1
    addi a0, x0, 36
    blt a1, s0, err_handle
    lw s0, 4(sp)
    lw a0, 0(sp)
    addi sp, sp, 8


    addi sp, sp, -20
    sw a2, 0(sp)    
    sw a3, 4(sp)
    sw t0, 8(sp)
    sw a4, 12(sp)
    sw s0, 16(sp)
    addi a4, x0, 0
    addi a2, x0, -1024 
loop_continue: #a0 is the pointer, a1 is the num of array, a2 is the max, a3 is the max_idx,t0 is tmp, a4 is idx
    beqz a1, loop_end
    addi a1, a1, -1
    lw s0, 0(a0)
    blt s0, a2, next_loop
    add a2, x0, s0
    add a3, x0, a4
next_loop:
    addi a4, a4, 1
    addi a0, a0, 4
    j loop_continue
    

loop_end:
    add a0, x0, a3
    lw s0, 16(sp)
    lw a4, 12(sp)
    lw t0, 8(sp)
    lw a3, 4(sp)
    lw a2, 0(sp)
    addi sp, sp 20
    # Epilogue
    ret
err_handle:
    lw s0, 4(sp)
    addi sp, sp, 8
    j exit