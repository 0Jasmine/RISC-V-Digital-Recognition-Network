.globl classify

.data
row: .word 0
column: .word 0

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    addi t0,x0,5
    bne a0,t0,toend
    addi sp,sp,-8
    sw ra,0(sp)
    sw a2,4(sp)

    add t0,x0,a1
    addi t0,t0,4

	# =====================================
    # LOAD MATRICES
    # =====================================


    # Load pretrained m0

    addi sp,sp,-4
    sw t0,0(sp)
    add a0,x0,t0
    lw a0,0(a0)
    la a1,row
    la a2,column
    jal read_matrix
    add t1,a0,x0
    lw t0,0(sp)
    addi t0,t0,4
    add s1,a1,x0
    add s2,a2,x0

    # Load pretrained m1
    addi sp,sp,-4
    sw t1,0(sp)
    sw t0,4(sp)
    add a0,x0,t0
    lw a0,0(a0)
    la a1,row
    la a2,column
    jal read_matrix
    add t2,a0,x0
    lw t0,4(sp)
    addi t0,t0,4
    add s3,a1,x0
    add s4,a2,x0


    # Load input matrix
    addi sp,sp,-4
    sw t2,0(sp)
    sw t0,8(sp)
    add a0,x0,t0
    lw a0,0(a0)
    la a1,row
    la a2,column
    jal read_matrix
    add t3,a0,x0
    lw t0,8(sp)
    lw t1,4(sp)
    lw t2,0(sp)
    addi sp,sp,12
    addi t0,t0,4
    add s5,a1,x0
    add s6,a2,x0


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    addi sp,sp,-16
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)

    mul a0,s1,s6
    slli a0,a0,2
    jal ra,malloc
    add a6,a0,x0

    lw t0,0(sp)
    lw t1,4(sp)
    lw t2,8(sp)
    lw t3,12(sp)

    add a0,t1,x0
    add a1,s1,x0
    add a2,s2,x0
    add a3,t3,x0
    add a4,s5,x0
    add a5,s6,x0
    jal ra,matmul
    add a0,a6,x0
    mul a1,s1,s6
    jal ra,relu

    mul a0,s3,s6
    slli a0,a0,2
    addi sp,sp,-4
    sw a6,0(sp)
    jal ra,malloc
    lw a3,0(sp)
    addi sp,sp,4
    add a6,a0,x0

    lw t2,8(sp)
    add a0,t2,x0
    add a1,s3,x0
    add a2,s4,x0
    add a4,s1,x0
    add a5,s6,x0
    jal ra,matmul
    add s0,a6,x0



    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw t0,0(sp)
    add a0,t0,x0
    lw a0,0(a0)
    add a1,s0,x0
    add a2,s3,x0
    add a3,s6,x0
    jal ra,write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    add a0,s0,x0
    mul a1,s3,s6
    jal ra,argmax

    add t0,a0,x0
    sw t0,0(sp)

    lw t1,4(sp)
    add a0,t1,x0
    jal ra,free

    lw t2,8(sp)
    add a0,t2,x0
    jal ra,free

    lw t3,12(sp)
    add a0,t3,x0
    jal ra,free

    add a0,s0,x0
    jal ra,free

    lw t0,0(sp)
    addi sp,sp,16


    lw a2,4(sp)
    bne a2,x0,restore
    # Print classification
    add a1,t0,x0
    jal ra,print_int

    # Print newline afterwards for clarity
    li a1,'\n'
    jal ra,print_char

restore:
    lw ra,0(sp)
    addi sp,sp,8

toend:
    ret