.globl abs

.text
abs:
    addi sp, sp, -4
    sw t0, 0(sp)
    # Load number from memory
    lw t0 0(a0)
    bge t0, zero, done
    # Negate a0
    sub t0, x0, t0
    # Store number back to memory
    sw t0 0(a0)
done:
    lw t0, 0(sp)
    addi sp, sp, 4
    jr ra