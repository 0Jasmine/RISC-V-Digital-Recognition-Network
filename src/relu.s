.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    addi sp,sp,-4
    sw  ra,0(sp)

loop_start:
    add t1,a0,x0
    addi a0,x0,8
    slti t0,a1,1
    bne t0,x0,loop_end
    add a0,x0,t1

loop_continue:
    beq t0,a1,loop_end
    slli t1,t0,2
    add t1,a0,t1
    lw t2,0(t1)
    addi t0,t0,1
    bge t2,x0,loop_continue
    sw x0,0(t1)
    beq x0,x0,loop_continue


loop_end:
    # Epilogue
    lw ra,0(sp)
    addi sp,sp,4
	ret