.globl write_matrix
.data
row: .word 0
column: .word 0

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp,sp,-12
    sw ra,0(sp)
    sw s0,4(sp)
    sw s1,8(sp)

    # copy
    add s0,a1,x0
    add t0,a2,x0
    add t1,a3,x0

    # open
    add a1,x0,a0
    addi a2,x0,1
    jal ra,fopen
    blt a0,x0,end
    add s1,x0,a0

    # store row
    add a1,x0,s1
    la t2,row
    sw t0,0(t2)
    add a2,x0,t2
    addi a3,x0,1
    addi a4,x0,4
    jal ra,fwrite
    blt a0,a3,end

    # store column
    add a1,x0,s1
    la t2,column
    sw t1,0(t2)
    add a2,x0,t2
    addi a3,x0,1
    addi a4,x0,4
    jal ra,fwrite
    blt a0,a3,end

    # store data
    add a1,x0,s1  
    add a2,s0,x0
    mul a3,t0,t1
    addi a4,x0,4
    jal ra,fwrite
    blt a0,a3,end

    # flush
    add a1,x0,s1
    jal ra,fflush
    blt a0,x0,end

    # close
    add a1,x0,s1
    jal ra,fclose
end:
    # Epilogue
    lw ra,0(sp)
    lw s0,4(sp)
    lw s1,8(sp)
    addi sp,sp,12

    ret
