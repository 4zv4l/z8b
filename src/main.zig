const std = @import("std");
const Io = std.Io;
const Cpu8 = @import("cpu.zig");

pub const std_options: std.Options = .{ .log_level = .info };

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 2) {
        std.debug.print("usage: {s} [bin]\n", .{args[0]});
        return;
    }

    var vm = Cpu8.init();
    const path = args[1];
    _ = try Io.Dir.cwd().readFile(init.io, path, vm.memory[0..Cpu8.max_stack]);

    while (true) {
        vm.step() catch |err| switch (err) {
            error.Break => return,
            else => return err,
        };
    }
}
