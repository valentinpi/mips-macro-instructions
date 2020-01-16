.globl foo
.globl bitwise_rotate

.macro mov dst, src
    sw \src, 4($sp)
    lw \dst, 4($sp)
.endm

.macro push src
    addi $sp, $sp, 4
    sw \src, 0($sp)
.endm

.macro pop dst
    lw \dst, 0($sp)
    # There is no subi instruction in the current version
    # of the MIPS instruction set
    addi $sp, $sp, -4
.endm

.macro multt dst src1 src2
    # Preserve value of src1
    sw \src1, 4($sp)
    mult \src1, \src2
    mflo \dst
    lw \src1, 4($sp)
.endm

# EXPERIMENTAL TODO:
.macro divt dst src1 src2
    sw \src1, 4($sp)
    div \src1, \src2
    mflo \dst
    lw \src1, 4($sp)
.endm

# EXPERIMENTAL TODO:
.macro mod dst src1 src2
    sw \src1, 4($sp)
    div \src1, \src2
    mfhi \dst
    lw \src1, 4($sp)
.endm

# EXPERIMENTAL TODO:
.macro not dst
    xor \dst, \dst, \dst
.endm

.macro clear dst
    mov \dst, $zero
.endm

.macro ror src const
    # To rotate, we shift the integer const bits right and
    # 32-const bits left and logical OR the result
    mov $t0, \src
    mov $t1, $zero
    addi $t1, $t1, 32
    addi $t1, $t1, -\const
    # Discard sign bit with srl
    # With sra you do not discard it
    srl \src, \src, \const
    sllv $t0, $t0, $t1
    or \src, \src, $t0
.endm

.macro rol src const
    mov $t0, \src
    mov $t1, $zero
    addi $t1, $t1, 32
    addi $t1, $t1, -\const
    sll \src, \src, \const
    # Discard sign bit with srlv
    # With srav you do not discard it
    srlv $t0, $t0, $t1
    or \src, \src, $t0
.endm

# EXPERIMENTAL TODO:
.macro bgt src1 src2 label
    # Save register first
    sw \src2, 4($sp)
    slt \src2, \src1
    mov $t0, \src2
    mov $t1, \src2
    lw \src2, 4($sp)
    beq $t0, $t1, \label
.endm

# EXPERIMENTAL TODO:
.macro ble src1 src2 label
    beq \src1, \src2, \label
    bgt \src2, \src1, \label
.endm

# Examples
# ATTENTION:
foo:
    mov $v0, $zero
    addi $v0, $v0, 5
    push $v0
    addi $v0, $v0, 5
    pop $v0
    # mov, push and pop are working
    multt $v0, $v0, $v0
    multt $v0, $v0, $v0
    multt $v0, $v0, $v0
    # multt is working
    divt $v0, $v0, $v0
    mod $v0, $v0, $v0
    # divt and modt not tested yet, but TODO:
    clear $v0
    # clear is working
    addi $v0, 1
    # $v0: 1
    bgt $v0, $zero, add_five
    # $v0: 1
    j $ra
add_five:
    addi $v0, 5
    # $v0: 6
    # bgt is working
    ble $zero, $v0, sub_five
    # $v0: 6
    j $ra
sub_five:
    addi $v0, -2
    # $v0: 4
    # 4 should be the correct output considering the branches
    j $ra

# Paper on MIPS calling conventions:
# https://courses.cs.washington.edu/courses/cse410/09sp/examples/MIPSCallingConventionsSummary.pdf
# The ror and rol instructions appear to be working
bitwise_rotate:
    beq $a1, $zero, bitwise_rotate_left
    j bitwise_rotate_right
bitwise_rotate_left:
    beq $a2, $zero, bitwise_rotate_quit
    rol $a0, 1
    addi $a2, $a2, -1
    j bitwise_rotate_left
bitwise_rotate_right:
    beq $a2, $zero, bitwise_rotate_quit
    ror $a0, 1
    addi $a2, $a2, -1
    j bitwise_rotate_right
bitwise_rotate_quit:
    mov $v0, $a0
    j $ra
