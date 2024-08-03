const std = @import("std");
const Cpu8 = @import("cpu.zig");
const Fmt = @import("fmt.zig");

pub fn main() !void {
    var vm = Cpu8.init();
    try vm.step();
    try vm.step();
    try vm.step();
}
