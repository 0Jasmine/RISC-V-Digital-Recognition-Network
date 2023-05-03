.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:
    # Prologue

    bne a2,a4,outer_loop_end
    slti t0,a1,1
    slti t0,a2,1
    slti t0,a4,1
    slti t0,a5,1
    bne t0,x0,outer_loop_end
    add t1,x0,x0

outer_loop_start:
    beq t1,a1,outer_loop_end
    mul t2,t1,a2
    slli t2,t2,2
    add t2,a0,t2
    add t3,x0,x0

inner_loop_start:
    beq t3,a5,inner_loop_end
    slli t4,t3,2
    add t4,a3,t4
    mul t5,t1,a5
    add t5,t5,t3
    slli t5,t5,2
    add t5,a6,t5

    addi sp,sp,-20
    sw a0,0(sp)
    sw a1,4(sp)
    sw a3,8(sp)
    sw a4,12(sp)
    sw ra,16(sp)

    add a0,t2,x0
    add a1,t4,x0
    addi a3,x0,1
    add a4,x0,a5
    jal ra,dot
    sw a0,0(t5)

    lw a0,0(sp)
    lw a1,4(sp)
    lw a3,8(sp)
    lw a4,12(sp)
    lw ra,16(sp)
    addi sp,sp,20

    addi t3,t3,1
    beq x0,x0,inner_loop_start

inner_loop_end:

    addi t1,t1,1
    beq x0,x0,outer_loop_start

outer_loop_end:

    ret