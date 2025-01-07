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
    # Prologue
    addi t0, x0, 1  # 1

    # Check if the stride of the array is less than 1
    blt a3, t0, terminate_with_error37
    blt a4, t0, terminate_with_error37

    # Check if the length of the array is less than 1
    blt a2, t0, terminate_with_error36

    mv t0 a0    # arr0*
    mv t1 a1    # arr1*
    mv t2 x0    # num

    mv a0 x0    # sum
 
    slli a3 a3 2    # stride*4
    slli a4 a4 2    # stride*4

loop_start:

    lw t3 0 (t0)
    lw t4 0 (t1)
    mul t3 t3 t4

    add a0 a0 t3

    add t0 t0 a3
    add t1 t1 a4
    addi t2 t2 1

    blt t2 a2 loop_start

    j loop_end



loop_end:
    # Epilogue

    jr ra


terminate_with_error37:
    li a0, 37             # Load error code 37 into a0
    li a7, 10             # Load system call number for exit (10) into a7
    ecall                 # Make the system call to terminate the program

terminate_with_error36:
    li a0, 36             # Load error code 36 into a0
    li a7, 10             # Load system call number for exit (10) into a7
    ecall                 # Make the system call to terminate the program