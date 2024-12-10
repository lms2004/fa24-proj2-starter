.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Check if the length of the array is less than 1
    bge x0, a1, terminate_with_error

    mv t0 a0    # arr*
    mv t1 x0    # i
    
    lw t2 0(t0) # max
    mv t3 x0    # index


loop_start:
    bge t1 a1 loop_end
    lw t4 0(t0)
    blt t4 t2 loop_continue
    
    mv t2 t4
    mv t3 t1
    
loop_continue:
    addi t1 t1 1
    addi t0 t0 4
    j loop_start
    
loop_end:
    mv a0 t3

    jr ra


terminate_with_error:
    li a0, 36             # Load error code 36 (exit code) into a0
    li a7, 10             # Load system call number for exit (10) into a7
    ecall                 # Make the system call to terminate the program
