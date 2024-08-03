const std = @import("std");
pub const Registers = std.EnumArray(Register, u8);
pub const Register = enum(u8) { A, B, C, BP, SP, PC };

pub fn fmtRegistersImpl(
    self: Registers,
    comptime _: []const u8,
    _: std.fmt.FormatOptions,
    writer: anytype,
) !void {
    try writer.print(
        \\A: 0x{x:0>2}        BP: 0x{x:0>2}
        \\B: 0x{x:0>2}        SP: 0x{x:0>2}
        \\C: 0x{x:0>2}        PC: 0x{x:0>2}
    , .{
        self.get(.A),
        self.get(.BP),
        self.get(.B),
        self.get(.SP),
        self.get(.C),
        self.get(.PC),
    });
}
