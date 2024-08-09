# z8b

very simple 8bit cpu in Zig

## Instructions

Instructions are on two bytes:
```
0000 0000 | 0000 0000
Operation   Args
            REG1 REG2       ex: add   A B
            Literal         ex: pushl 5
                 REG2       ex: push  A
```

- `Nop`: Does nothing
- `Add` [Register1, Register2]: Register1 += Register2, set FLAGS to 1 if overflow
- `Sub` [Register1, Register2]: Register1 -= Register2, set FLAGS to 1 if underflow
- `Push` [Regitster]: Push the value in the register into the stack
- `Pushl` [Literal]: Push the value into the stack
- `Pop` [Register]: Pop value from the stack into the register
- `Jmp` [Addr]: Jump to the address
- `Jmpz` [Addr]: Jump to the address if FLAGS is 0
- `Jmpnz` [Addr]: Jump to the address if FLAGS is **not** 0
- `Cmp` [Register1, Register2]: Set FLAGS to 0 if both registers are equal, otherwise 1
- `Brk`: Stop the VM

## Example

Given this example code:

```
; A = 3
; C = 1
; B = 0
; while (A != B) B += C;

start:
    pushl 3      ; A = 3
    pop   A
    pushl 1      ; C = 1
    pop   C
loop_start:      ; loop until B == A
    cmp   A B
    jmpz  #exit
    add   B C    ; increment B by C
    jmp   #loop_start
exit:
    brk
```

Assembled using [this assembler](https://github.com/4zv4l/z8basm)

Run it:

```
$ ./z8b rom.bin
---------- step ----------
info: fetched: 0x0403
info: decoded: instruction{ .operation = instruction.Operation.Pushl, .args = 3 }
info: registers:
A: 0x00        BP: 0xff
B: 0x00        SP: 0xfe
C: 0x00        PC: 0x02     FLAGS: 0x00
stack: [ 3, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0500
info: decoded: instruction{ .operation = instruction.Operation.Pop, .args = 0 }
info: registers:
A: 0x03        BP: 0xff
B: 0x00        SP: 0xff
C: 0x00        PC: 0x04     FLAGS: 0x00
stack: [ 3, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0401
info: decoded: instruction{ .operation = instruction.Operation.Pushl, .args = 1 }
info: registers:
A: 0x03        BP: 0xff
B: 0x00        SP: 0xfe
C: 0x00        PC: 0x06     FLAGS: 0x00
stack: [ 1, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0502
info: decoded: instruction{ .operation = instruction.Operation.Pop, .args = 2 }
info: registers:
A: 0x03        BP: 0xff
B: 0x00        SP: 0xff
C: 0x01        PC: 0x08     FLAGS: 0x00
stack: [ 1, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0901
info: decoded: instruction{ .operation = instruction.Operation.Cmp, .args = 1 }
info: registers:
A: 0x03        BP: 0xff
B: 0x00        SP: 0xff
C: 0x01        PC: 0x0a     FLAGS: 0x01
stack: [ 1, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0710
info: decoded: instruction{ .operation = instruction.Operation.Jmpz, .args = 16 }
info: registers:
A: 0x03        BP: 0xff
B: 0x00        SP: 0xff
C: 0x01        PC: 0x0c     FLAGS: 0x01
stack: [ 1, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0112
info: decoded: instruction{ .operation = instruction.Operation.Add, .args = 18 }
info: registers:
A: 0x03        BP: 0xff
B: 0x01        SP: 0xff
C: 0x01        PC: 0x0e     FLAGS: 0x00
stack: [ 1, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0608
info: decoded: instruction{ .operation = instruction.Operation.Jmp, .args = 8 }
info: registers:
A: 0x03        BP: 0xff
B: 0x01        SP: 0xff
C: 0x01        PC: 0x08     FLAGS: 0x00
stack: [ 1, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0901
info: decoded: instruction{ .operation = instruction.Operation.Cmp, .args = 1 }
info: registers:
A: 0x03        BP: 0xff
B: 0x01        SP: 0xff
C: 0x01        PC: 0x0a     FLAGS: 0x01
stack: [ 1, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0710
info: decoded: instruction{ .operation = instruction.Operation.Jmpz, .args = 16 }
info: registers:
A: 0x03        BP: 0xff
B: 0x01        SP: 0xff
C: 0x01        PC: 0x0c     FLAGS: 0x01
stack: [ 1, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0112
info: decoded: instruction{ .operation = instruction.Operation.Add, .args = 18 }
info: registers:
A: 0x03        BP: 0xff
B: 0x02        SP: 0xff
C: 0x01        PC: 0x0e     FLAGS: 0x00
stack: [ 1, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0608
info: decoded: instruction{ .operation = instruction.Operation.Jmp, .args = 8 }
info: registers:
A: 0x03        BP: 0xff
B: 0x02        SP: 0xff
C: 0x01        PC: 0x08     FLAGS: 0x00
stack: [ 1, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0901
info: decoded: instruction{ .operation = instruction.Operation.Cmp, .args = 1 }
info: registers:
A: 0x03        BP: 0xff
B: 0x02        SP: 0xff
C: 0x01        PC: 0x0a     FLAGS: 0x01
stack: [ 1, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0710
info: decoded: instruction{ .operation = instruction.Operation.Jmpz, .args = 16 }
info: registers:
A: 0x03        BP: 0xff
B: 0x02        SP: 0xff
C: 0x01        PC: 0x0c     FLAGS: 0x01
stack: [ 1, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0112
info: decoded: instruction{ .operation = instruction.Operation.Add, .args = 18 }
info: registers:
A: 0x03        BP: 0xff
B: 0x03        SP: 0xff
C: 0x01        PC: 0x0e     FLAGS: 0x00
stack: [ 1, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0608
info: decoded: instruction{ .operation = instruction.Operation.Jmp, .args = 8 }
info: registers:
A: 0x03        BP: 0xff
B: 0x03        SP: 0xff
C: 0x01        PC: 0x08     FLAGS: 0x00
stack: [ 1, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0901
info: decoded: instruction{ .operation = instruction.Operation.Cmp, .args = 1 }
info: registers:
A: 0x03        BP: 0xff
B: 0x03        SP: 0xff
C: 0x01        PC: 0x0a     FLAGS: 0x00
stack: [ 1, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0710
info: decoded: instruction{ .operation = instruction.Operation.Jmpz, .args = 16 }
info: registers:
A: 0x03        BP: 0xff
B: 0x03        SP: 0xff
C: 0x01        PC: 0x10     FLAGS: 0x00
stack: [ 1, 0, 0, 0, 0 ]
---------- step ----------
info: fetched: 0x0a00
info: decoded: instruction{ .operation = instruction.Operation.Brk, .args = 0 }
info: registers:
A: 0x03        BP: 0xff
B: 0x03        SP: 0xff
C: 0x01        PC: 0x10     FLAGS: 0x00
stack: [ 1, 0, 0, 0, 0 ]
~~~ BREAK INSTRUCTION ~~~
```
