.text
    addi sp,sp,-12
    sw a0,0(sp)
    sw a1,4(sp)
    sw ra,8(sp)
    add a1,t2,x0
    jal ra,print_int
    li a1,'\n'
    jal ra,print_char
    lw ra,8(sp)
    lw a1,4(sp)
    lw a0,0(sp)
    addi sp,sp,12