.globl foo
.globl bitwise_rotate

.macro mov dst, src
    xor \dst, \dst, \dst
    add \dst, \src
.endm

.macro push src
    # Stack grows from high addresses to low addresses
    # See memory map: http://wilkinsonj.people.cofc.edu/mem-map.html
    addi $sp, $sp, -4
    sw \src, 0($sp)
.endm

.macro pop dst
    lw \dst, 0($sp)
    # There is no subi instruction in the current version
    # of the MIPS instruction set
    addi $sp, $sp, 4
.endm

.macro multt dst src1 src2
    # Preserve value of src1
    mult \src1, \src2
    mflo \dst
.endm

.macro divt dst src1 src2
    div \src1, \src2
    mflo \dst
.endm

.macro mod dst src1 src2
    div \src1, \src2
    mfhi \dst
.endm

.macro not dst
    nor \dst, \dst, \dst
.endm

.macro clear dst
    xor \dst, \dst, \dst
.endm

.macro ror src const
    # To rotate, we shift the integer const bits right and
    # 32-const bits left and logical OR the result
    mov $t0, \src
    clear $t1
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
    clear $t1
    addi $t1, $t1, 32
    addi $t1, $t1, -\const
    sll \src, \src, \const
    # Discard sign bit with srlv
    # With srav you do not discard it
    srlv $t0, $t0, $t1
    or \src, \src, $t0
.endm

.macro bgt src1 src2 label
    # Save register first
    sw \src2, 4($sp)
    slt \src2, \src1
    mov $t0, \src2
    mov $t1, \src2
    lw \src2, 4($sp)
    beq $t0, $t1, \label
.endm

.macro ble src1 src2 label
    beq \src1, \src2, \label
    bgt \src2, \src1, \label
.endm

# Examples
# Tests the mov, push, pop, multt, clear, bgt and ble instructions
foo:
    mov $v0, $zero
    addi $v0, $v0, 5
    push $v0
    addi $v0, $v0, 5
    pop $v0
    multt $v0, $v0, $v0
    multt $v0, $v0, $v0
    multt $v0, $v0, $v0
    divt $v0, $v0, $v0
    mod $v0, $v0, $v0
    clear $v0
    addi $v0, 1
    # $v0: 1
    not $v0
    not $v0
    # $v0 should be 1 if not is working
    bgt $v0, $zero, add_five
    # $v0: 1
    j $ra
add_five:
    addi $v0, 5
    # $v0: 6
    ble $zero, $v0, sub_five
    # $v0: 6
    j $ra
sub_five:
    addi $v0, -2
    mov $t0, $zero
    addi $t0, $t0, 2
    divt $v0, $v0, $t0
    addi $v0, $v0, 1
    addi $t0, $t0, 1
    mod $v0, $v0, $t0
    # $v0: 0
    # 0 should be the correct output considering the branches
    # and all instructions used
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
