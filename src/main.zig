const std = @import("std");
const Cpu8 = @import("cpu.zig");
const Fmt = @import("fmt.zig");

pub const std_options: std.Options = .{ .log_level = .info };

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 2) {
        std.debug.print("usage: {s} [bin]\n", .{args[0]});
        return;
    }

    var vm = Cpu8.init();
    const path = args[1];
    _ = try std.fs.cwd().readFile(path, vm.memory[0..Cpu8.max_stack]);

    // 12 cycles required for current test program
    for (0..12) |_| {
        try vm.step();
    }
}
