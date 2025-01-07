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
    
    # make sense
    bge x0 a1 error
    bge x0 a2 error
    bge x0 a4 error
    bge x0 a5 error
    
    # match
    bne a2 a4 error

    
    # 创建栈帧
    addi sp sp -48

    addi t3 x0 0 # 初始化 i

outer_loop_start:
    bge t3 a1 outer_loop_end # i >= a1
    
    addi t3 t3 1 # i++

    addi t1 x0 0 # 初始化 j

    sw a3 0(sp)     # save *arr1

inner_loop_start:
    bge t1 a5 inner_loop_end # j >= a5 (arr1.col)

    sw a0 4(sp)     # save m0
    sw a1 8(sp)     # save m0 row
    sw a2 12(sp)    # save m0 col
    sw a3 16(sp)    # save m1
    sw a4 20(sp)    # save m1 row
    sw a5 24(sp)    # save m1 col
    sw a6 28(sp)    # save *C
    sw t1 32(sp)    # save j
    sw t3 36(sp)    # save i
    sw ra 40(sp)    # save ra

    addi a0 a0 0    # parm a0(default):    *arr0
    mv a1 a3        # parm a1:          *arr1

    addi a2 a2 0    # parm a2:  (default arr0.col = arr1.row)

    addi a3 x0 1    # parm a3: strides of arr0
    mv a4 a5        # parm a4: strides of arr1    (arr1.col)

    jal dot         #  V(i,j)  Dot(fuc) -> a0
    lw a6 28(sp)    # restore *C

    sw a0 0(a6)     #   V(i,j) -> C[i][j]
    addi a6 a6 4    #  C[i][j] -> C[i][j+1]


    lw a0 4(sp)     # restore m0
    lw a1 8(sp)     # restore m0 row
    lw a2 12(sp)    # restore m0 col
    lw a3 16(sp)    # restore m1
    lw a4 20(sp)    # restore m1 row
    lw a5 24(sp)    # restore m1 col
    # lw a6 28(sp)    # 不再需要再次恢复 a6，因为已经在上面恢复过
    lw t1 32(sp)    # restore j
    lw t3 36(sp)    # restore i
    lw ra 40(sp)    # restore ra

    addi t1 t1 1 # j++
    addi a3 a3 4 # &arr1[0][j] -> &arr1[0][j+1]
    j inner_loop_start
    


inner_loop_end:
    lw a3 0(sp)     # restore *arr1 -> &arr[0][0]
    slli t0 a2 2
    add a0 a0 t0   # &arr[0][0] -> &arr[1][0]
    j outer_loop_start

outer_loop_end:
    addi sp sp 48

    # Epilogue
    jr ra


error:
    li a0, 38
    j exit
