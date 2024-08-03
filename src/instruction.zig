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
const Operation = enum(u8) { Nop, Add };

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
        .Add => {
            const regs = try getReg(cpu, self.args);
            regs[0].* += regs[1].*;
        },
        .Nop => {},
    }
}

fn getReg(cpu: *Cpu, raw: u8) ![2]*Register.Registers.Value {
    const regs: packed struct { r1: u4, r2: u4 } = @bitCast(raw);
    const r1 = std.meta.intToEnum(Register.Register, regs.r1) catch return error.InvalidRegister;
    const r2 = std.meta.intToEnum(Register.Register, regs.r2) catch return error.InvalidRegister;
    return .{ cpu.registers.getPtr(r1), cpu.registers.getPtr(r2) };
}
