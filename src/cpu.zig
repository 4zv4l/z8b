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
            .BP = 0,
            .SP = 0,
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
    self.registers.set(.PC, self.registers.get(.PC) + 2);
    std.log.info("fetched: 0x{x:0>2}", .{raw_instruction});

    const instruction = try Instruction.decode(raw_instruction);
    std.log.info("decoded: {}", .{instruction});

    try instruction.execute(self);
    std.log.info("registers:\n{}", .{Fmt.fmtRegisters(self.registers)});
}
