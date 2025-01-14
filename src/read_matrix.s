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
    # Prologue
    addi sp sp -24
    sw ra 20(sp)
# open file
    # fopen
    #   a0 file pointer
    #   a1 pemissional bit
    #  return a0: file descriptor
    sw a1 0(sp)
    sw a2 4(sp)

    mv a1 x0
    jal fopen

    bge x0 a0 fopen_error
    
    lw a1 0(sp) # restore a1
    lw a2 4(sp) # restore a2

# read row and col
    # fread
    #   a0 file descriptor
    #   a1 buffer pointer
    #   a2 number of bytes
    #  return a0: acutal number of bytes read

    # read row
    sw a0 0(sp)
    sw a1 4(sp)
    sw a2 8(sp)

    mv a0 a0    # file descriptor
    mv a1 a1    # row
    li a2 4     # number of bytes

    sw a2 12(sp)

    jal fread

    lw t0 12(sp)

    bne a0 t0 fread_error

    lw a0 0(sp)
    lw a1 4(sp)
    lw a2 8(sp)

    # read col

    sw a0 0(sp) # save row
    sw a1 4(sp)
    sw a2 8(sp)


    mv a0 a0    # file descriptor
    mv a1 a2    # col
    li a2 4     # number of bytes

    sw a2 12(sp)

    jal fread

    lw t0 12(sp)
    
    bne a0 t0 fread_error

    lw a0 0(sp)
    lw a1 4(sp)
    lw a2 8(sp)
    
    # Caculate nums of elements
    lw t0 0(a1)
    lw t1 0(a2)

    mul t2 t0 t1
    slli t2 t2 2

    # Malloc memory
    #   malloc: 
    #       a0: bytes
    #    return a0: memory pointer
    sw a0 0(sp)
    sw a1 4(sp)
    sw a2 8(sp)
    sw t2 12(sp)

    mv a0 t2
    jal malloc

    beq x0 a0 malloc_error

    sw a0 16(sp)    # save memory pointer

    lw a0 0(sp)
    lw a1 4(sp)
    lw a2 8(sp)
    lw t2 12(sp)

    # read elements
    sw a0 0(sp)
    sw a1 4(sp)
    sw a2 8(sp)

    lw t0 16(sp)    # load memory pointer
    mv a0 a0    # file descriptor
    mv a1 t0    # memory pointer
    mv a2 t2    # number of bytes

    sw a2 12(sp)

    jal fread

    lw t0 12(sp)

    bne a0 t0 fread_error
    
    lw a0 0(sp)
    lw a1 4(sp)
    lw a2 8(sp)

    # close file 
    jal fclose

    bne a0 x0 fclose_error

    lw a0 16(sp)    # load memory pointer
    lw ra 20(sp)
    addi sp sp 24
    # Epilogue
    jr ra


malloc_error:
    li a0 26
    j exit 

fopen_error:
    li a0 27
    j exit

fclose_error:
    li a0 28
    j exit

fread_error:
    li a0 29
    j exit

