.import ../../src/dot.s
.import ../../src/utils.s

# Set vector values for testing
.data
vector0: .word 1 2 3 
vector1: .word 1 2 3 4 5 6


.text
# main function for testing
main:
    # Load vector addresses into registers
    la s0 vector0
    la s1 vector1

    # Set vector attributes
    add a0,s0,x0
	add a1,s1,x0
	addi a2,x0,3
	addi a3,x0,1
	addi a4,x0,2

    # Call dot function
    jal ra,dot


    # Print integer result
	add a1,a0,x0
	jal ra,print_int


    # Print newline
	li a1,'\n'
	jal ra,print_char


    # Exit
    jal exit
