        .globl relu

    .text
    # ==============================================================================
    # FUNCTION: Performs an inplace element-wise ReLU on an array of ints
    # Arguments:
    # 	a0 (int*) is the pointer to the array
    #	a1 (int)  is the # of elements in the array
    # Returns:
    #	None
    # Exceptions:
    # - If the length of the vector is less than 1,
    #   this function terminates the program with error code 36.
    # ==============================================================================
    relu:
        # Prologue
    loop_start:
        addi sp, sp, -8
        sw a0, 0(sp)
        sw s0, 4(sp)
        addi s0, x0, 1
        li a0, 36
        blt a1, s0, err_handle
        lw s0, 4(sp)
        lw a0, 0(sp)
        addi sp, sp, 8
        addi sp, sp, 4
        sw t0, 0(sp)
    loop_continue:
        beqz a1, loop_end
        addi a1, a1, -1
        lw t0, 0(a0)
        blt t0, x0, handle_neg
        addi a0, a0, 4
        j loop_continue
    handle_neg:
        addi t0, x0, 0
           sw t0, 0(a0)
        addi a0, a0, 4
        j loop_continue
        
    err_handle:
        lw s0, 4(sp)
        addi sp, sp, 8
        j exit

    loop_end:
        lw t0, 0(sp)
        addi sp, sp, -4
        # Epilogue
        ret
