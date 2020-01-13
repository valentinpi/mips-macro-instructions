.globl foo

.macro mov reg1, reg2
    sw \reg2, 4($sp)
    lw \reg1, 4($sp)
.endm

; Examples
foo:
    mov $v0, $zero
    addi $v0, $v0, 1
    addi $v0, $v0, 1
    addi $v0, $v0, 1
    addi $v0, $v0, 1
    addi $v0, $v0, 1
    jal $ra
