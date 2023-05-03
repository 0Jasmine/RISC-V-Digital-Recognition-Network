.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "tests/inputs/simple2/bin/m0.bin"
row: .word 0
column: .word 0

.text
main:
    # Read matrix into memory
    la a0,file_path
    la a1,row
    la a2,column
    jal ra,read_matrix

    # Print out elements of matrix
    jal print_int_array

    # Terminate the program
    jal x0,exit