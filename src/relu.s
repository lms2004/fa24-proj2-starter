.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    blt a1, x0, terminate_with_error

    addi t0, a0, 0
    addi t1, x0, 0
    j loop_start

loop_start:
    bge t1, a1, loop_end

    lw t2, 0(t0)
    addi t1, t1, 1
    bge t2, x0, loop_continue
    sw x0, 0(t0)
    addi t0, t0, 4
    blt t1, a1, loop_start

loop_continue:
    addi t0, t0, 4
    j loop_start


loop_end:
    # Epilogue


    jr ra

terminate_with_error:
    li a0, 36             # Load error code 36 (exit code) into a0
    li a7, 10             # Load system call number for exit (10) into a7
    ecall                 # Make the system call to terminate the program
