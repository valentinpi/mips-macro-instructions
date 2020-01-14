.globl foo

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
    mult \src1, \src2
    mflo \dst
.endm

# TODO: Implement
.macro divt dst src1 src2
.endm

# TODO: Implement
.macro mod dst src1 src2
.endm

# TODO: Implement
.macro not dst
.endm

.macro clear dst
    mov \dst, $zero
.endm

# TODO: Implement
.macro ror src const
.endm

# TODO: Implement
.macro rol src const
.endm

# TODO: Implement
.macro bgt src1 src2 label
.endm

# TODO: Implement
.macro ble src1 src2 label
.endm

# Examples
foo:
    mov $v0, $zero
    addi $v0, $v0, 1
    addi $v0, $v0, 1
    addi $v0, $v0, 1
    addi $v0, $v0, 1
    addi $v0, $v0, 1
    push $v0
    pop $v0
    multt $v0, $v0, $v0
    multt $v0, $v0, $v0
    multt $v0, $v0, $v0
    clear $v0
    addi $v0, 1
    jal $ra
