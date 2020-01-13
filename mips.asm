.globl foo

.macro mov reg1, reg2
    sw \reg2, 4($sp)
    lw \reg1, 4($sp)
.endm

.macro push reg
    addi $sp, $sp, 4
    sw \reg, 0($sp)
.endm

.macro pop reg
    lw \reg, 0($sp)
    # Zero-out stack top
    sw $zero, 0($sp)
    # There is no subi instruction in the current version
    # of the MIPS instruction set
    addi $sp, $sp, -4
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
    jal $ra
