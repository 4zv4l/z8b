const std = @import("std");
pub const Registers = std.EnumArray(Register, u8);
pub const Register = enum(u8) { A, B, C, BP, SP, PC, FLAGS };

const RegFmt = struct {
    data: Registers,

    pub fn fmt(self: RegFmt, writer: *std.Io.Writer) !void {
        try writer.print(
            \\A: 0x{x:0>2}        BP: 0x{x:0>2}
            \\B: 0x{x:0>2}        SP: 0x{x:0>2}
            \\C: 0x{x:0>2}        PC: 0x{x:0>2}     FLAGS: 0x{x:0>2}
        , .{
            self.data.get(.A),
            self.data.get(.BP),
            self.data.get(.B),
            self.data.get(.SP),
            self.data.get(.C),
            self.data.get(.PC),
            self.data.get(.FLAGS),
        });
    }
};

pub fn fmtRegs(regs: Registers) RegFmt {
    return .{ .data = regs };
}
