const std = @import("std");
const Registers = @import("registers.zig").Registers;
const Instruction = @import("instruction.zig");
const Fmt = @import("fmt.zig");
const Cpu = @This();

registers: Registers,
memory: [256]u8,

pub const end_stack = 255;
pub const max_stack = 250;

pub fn init() Cpu {
    return .{
        .registers = Registers.init(.{
            .A = 0,
            .B = 0,
            .C = 0,
            .BP = end_stack, // stack starts at addr 0xfa
            .SP = end_stack,
            .PC = 0,
            .FLAGS = 0,
        }),
        .memory = [_]u8{0} ** 256,
    };
}

fn printStack(stack: []const u8) void {
    var sep: []const u8 = " ";
    var stackit = std.mem.reverseIterator(stack);
    std.debug.print("stack: [", .{});
    while (stackit.next()) |v| {
        std.debug.print("{s}{d}", .{ sep, v });
        sep = ", ";
    }
    std.debug.print(" ]\n", .{});
}

pub fn step(self: *Cpu) !void {
    std.debug.print("---------- step ----------\n", .{});

    const raw_instruction = try Instruction.fetch(self.registers.get(.PC), &self.memory);
    std.log.info("fetched: 0x{x:0>4}", .{std.mem.toNative(u16, raw_instruction, .big)});

    const instruction = try Instruction.decode(raw_instruction);
    std.log.info("decoded: {}", .{instruction});

    instruction.execute(self) catch |err| switch (err) {
        error.Break => {
            std.log.info("registers:\n{}", .{Fmt.fmtRegisters(self.registers)});
            printStack(self.memory[max_stack..end_stack]);
            std.debug.print("~~~ BREAK INSTRUCTION ~~~\n", .{});
            return err;
        },
        else => return err,
    };
    std.log.info("registers:\n{}", .{Fmt.fmtRegisters(self.registers)});

    printStack(self.memory[max_stack..end_stack]);
}
