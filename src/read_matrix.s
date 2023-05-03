.globl read_matrix


.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
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
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp,sp,-8
    sw ra,0(sp)
    sw s0,4(sp)

    # open file
    add t0,x0,a1
    add t1,x0,a2
    add a1,x0,a0
    add a2,x0,x0
    jal ra,fopen
    slti t3,a0,-1
    bne t3,x0,end
    add s0,a0,x0

    # read row
    add a1,s0,x0
    add a2,x0,t0
    addi a3,x0,4
    jal ra,fread
    slti t3,a0,4
    bne t3,x0,end
    lw t4,0(t0)

    # read column
    add a1,s0,x0
    add a2,x0,t1
    addi a3,x0,4
    jal ra,fread
    slti t3,a0,4
    bne t3,x0,end
    lw t5,0(t1)

    # malloc
    mul a0,t4,t5
    slli a0,a0,2
    add t0,a0,x0
    jal ra,malloc
    add t1,a0,x0

    # read
    add a1,x0,s0
    add a2,x0,a0
    add a3,t0,x0
    jal ra,fread
    slt t3,a0,t0
    bne t3,x0,end

    # close
    add a1,x0,s0
    jal ra,fclose
    bne a0,x0,end

    add a0,x0,t1
    add a1,x0,t4
    add a2,x0,t5

end:
    # Epilogue
    lw ra,0(sp)
    lw s0,4(sp)
    addi sp,sp,8
    ret