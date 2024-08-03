const std = @import("std");
const Registers = @import("registers.zig");

pub fn fmtRegisters(regs: Registers.Registers) std.fmt.Formatter(Registers.fmtRegistersImpl) {
    return .{ .data = regs };
}
