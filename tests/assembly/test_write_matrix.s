.import ../../src/write_matrix.s
.import ../../src/utils.s

.data
m0: .word 1, 2, 3, 4, 5, 6, 7, 8 # MAKE CHANGES HERE TO TEST DIFFERENT MATRICES
file_path: .asciiz "tests/outputs/test_write_matrix/student_write_outputs.bin"

.text
main:
    # Write the matrix to a file
    la a0,file_path
    la a1,m0
    addi a2,x0,2
    addi a3,x0,4
    jal ra,write_matrix

    # Exit the program
    jal x0,exit
