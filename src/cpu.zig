const std = @import("std");
const Registers = @import("registers.zig").Registers;
const Instruction = @import("instruction.zig");
const Fmt = @import("fmt.zig");
const Cpu = @This();

registers: Registers,
memory: [256]u8,

pub fn init() Cpu {
    return .{
        .registers = Registers.init(.{
            .A = 0,
            .B = 0,
            .C = 0,
            .BP = 250,
            .SP = 250,
            .PC = 0,
        }),
        .memory = [_]u8{0} ** 256,
    };
}

// instruction:
// 0000 0000 | 0000 0000
// OP          ARGS
pub fn step(self: *Cpu) !void {
    std.debug.print("---------- step ----------\n", .{});

    const raw_instruction = try Instruction.fetch(self.registers.get(.PC), &self.memory);
    std.log.info("fetched: 0x{x:0>4}", .{std.mem.toNative(u16, raw_instruction, .big)});

    const instruction = try Instruction.decode(raw_instruction);
    std.log.info("decoded: {}", .{instruction});

    try instruction.execute(self);
    std.log.info("registers:\n{}", .{Fmt.fmtRegisters(self.registers)});
    std.debug.print("stack: {any}\n", .{self.memory[250..]});
}
