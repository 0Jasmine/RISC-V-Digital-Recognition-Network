.globl dot


.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    # Prologue
    addi sp,sp,-16
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)

loop_start:
    slti t0,a2,1
    slti t0,a3,1
    slti t0,a4,1
    bne t0,x0,loop_end
    add s0,x0,x0

loop_continue:
    beq t0,a2,loop_end
    mul t1,t0,a3
    slli t1,t1,2
    add  t1,t1,a0
    lw  t2,0(t1)
    mul t1,t0,a4
    slli t1,t1,2
    add t1,t1,a1
    lw t3,0(t1)
    mul t2,t2,t3
    add s0,s0,t2
    addi t0,t0,1
    beq x0,x0,loop_continue

loop_end:
    add a0,x0,s0

    # Epilogue
    lw t0,0(sp)
    lw t1,4(sp)
    lw t2,8(sp)
    lw t3,12(sp)
    addi sp,sp,16
    ret