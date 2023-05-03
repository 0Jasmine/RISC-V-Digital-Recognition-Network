.globl argmax

.import utils.s

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
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue
    addi sp,sp,-8
    sw  ra,0(sp)
    sw  s0,4(sp)

loop_start:
    slti t0,a1,1
    bne t0,x0,loop_end
    lw  t3,0(a0)
    add s0,x0,a0

loop_continue:
    beq t0,a1,loop_end
    slli t1,t0,2
    add t1,s0,t1
    lw  t2,0(t1)

    addi t0,t0,1
    bge t3,t2,loop_continue
    add a0,x0,t0
    addi a0,a0,-1
    add t3,x0,t2
    beq x0,x0,loop_continue

loop_end:

    # Epilogue
    lw s0,4(sp)
    lw ra,0(sp)
    addi sp,sp,8
    ret