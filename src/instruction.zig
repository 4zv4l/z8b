const std = @import("std");
const Cpu = @import("cpu.zig");
const Register = @import("registers.zig");
const Instruction = @This();

operation: Operation,
args: u8,

// instruction:
// 0000 0000 | 0000 0000
// OP          ARGS
//             REG1 REG2
//             8bit literal
const InstructionSize = u16;
const Operation = enum(u8) { Nop, Add, Sub, Push, Pushl, Pop, Jmp, Jmpz, Jmpnz, Cmp, Brk };

pub fn fetch(pc: u8, mem: []const u8) !InstructionSize {
    if (pc > (mem.len - 2)) return error.InvalidAddress;
    return @bitCast([2]u8{ mem[pc], mem[pc + 1] });
}

pub fn decode(raw: InstructionSize) !Instruction {
    const raw_op: u8 = @as([2]u8, @bitCast(raw))[0];
    const op = std.meta.intToEnum(
        Operation,
        raw_op,
    ) catch return error.InvalidOperation;

    const raw_args: u8 = @as([2]u8, @bitCast(raw))[1];

    return Instruction{ .operation = op, .args = raw_args };
}

pub fn execute(self: Instruction, cpu: *Cpu) !void {
    switch (self.operation) {
        .Brk => {
            return error.Break;
        },
        .Nop => {
            cpu.registers.set(.PC, cpu.registers.get(.PC) +% 2);
        },
        .Add => {
            const regs = try getRegs(cpu, self.args);
            const info = @addWithOverflow(regs[0].*, regs[1].*);
            regs[0].* = info[0];
            cpu.registers.set(.FLAGS, info[1]);

            cpu.registers.set(.PC, cpu.registers.get(.PC) +% 2);
        },
        .Sub => {
            const regs = try getRegs(cpu, self.args);
            const info = @subWithOverflow(regs[0].*, regs[1].*);
            regs[0].* = info[0];
            cpu.registers.set(.FLAGS, info[1]);

            cpu.registers.set(.PC, cpu.registers.get(.PC) +% 2);
        },
        .Push => {
            if (cpu.registers.get(.SP) == Cpu.max_stack) return error.StackOverflow;

            const reg = try getReg(cpu, self.args);

            cpu.registers.set(.SP, cpu.registers.get(.SP) -| 1);
            cpu.memory[cpu.registers.get(.SP)] = reg.*;

            cpu.registers.set(.PC, cpu.registers.get(.PC) +% 2);
        },
        .Pushl => {
            if (cpu.registers.get(.SP) == Cpu.max_stack) return error.StackOverflow;

            cpu.registers.set(.SP, cpu.registers.get(.SP) -| 1);
            cpu.memory[cpu.registers.get(.SP)] = self.args;

            cpu.registers.set(.PC, cpu.registers.get(.PC) +% 2);
        },
        .Pop => {
            if (cpu.registers.get(.SP) == Cpu.end_stack) return error.StackUnderflow;

            const reg = try getReg(cpu, self.args);
            reg.* = cpu.memory[cpu.registers.get(.SP)];
            cpu.registers.set(.SP, cpu.registers.get(.SP) +| 1);

            cpu.registers.set(.PC, cpu.registers.get(.PC) +% 2);
        },
        .Jmp => {
            const dest_addr = self.args;
            cpu.registers.set(.PC, dest_addr);
        },
        .Jmpz => {
            const dest_addr = self.args;
            if (cpu.registers.get(.FLAGS) == 0) {
                cpu.registers.set(.PC, dest_addr);
                return;
            }

            cpu.registers.set(.PC, cpu.registers.get(.PC) +% 2);
        },
        .Jmpnz => {
            const dest_addr = self.args;
            if (cpu.registers.get(.FLAGS) != 0) {
                cpu.registers.set(.PC, dest_addr);
                return;
            }

            cpu.registers.set(.PC, cpu.registers.get(.PC) +% 2);
        },
        .Cmp => { // if equal put 0 in FLAGS else 1
            const regs = try getRegs(cpu, self.args);
            cpu.registers.set(.FLAGS, if (regs[0].* == regs[1].*) 0 else 1);

            cpu.registers.set(.PC, cpu.registers.get(.PC) +% 2);
        },
    }
}

fn getRegs(cpu: *Cpu, raw: u8) ![2]*Register.Registers.Value {
    const r1 = std.meta.intToEnum(Register.Register, raw >> 4) catch return error.InvalidR1Register;
    const r2 = std.meta.intToEnum(Register.Register, raw & 0x0f) catch return error.InvalidR2Register;
    return .{ cpu.registers.getPtr(r1), cpu.registers.getPtr(r2) };
}

fn getReg(cpu: *Cpu, raw: u8) !*Register.Registers.Value {
    const reg = std.meta.intToEnum(Register.Register, raw & 0x0f) catch return error.InvalidR2Register;
    return cpu.registers.getPtr(reg);
}
