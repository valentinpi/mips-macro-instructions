.globl foo

.macro mov dst, src
    sw \src, 4($sp)
    lw \dst, 4($sp)
.endm

.macro push reg
    addi $sp, $sp, 4
    sw \reg, 0($sp)
.endm

.macro pop dst
    lw \dst, 0($sp)
    # Zero-out stack top
    sw $zero, 0($sp)
    # There is no subi instruction in the current version
    # of the MIPS instruction set
    addi $sp, $sp, -4
.endm

.macro multt dst reg1 reg2
    mult \reg1, \reg2
    mflo \dst
.endm

# div

# mod

# not

.macro clear dst
    # Alternative:
    # mov \dst, $zero
    sw $zero, 4($sp)
    lw \dst, 4($sp)
.endm

# ror

# rol

# bgt

# ble

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
    jal $ra
