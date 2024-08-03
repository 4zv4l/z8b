const std = @import("std");
const Cpu8 = @import("cpu.zig");
const Fmt = @import("fmt.zig");

pub fn main() !void {
    var vm = Cpu8.init();
    vm.memory[0] = 0x02; // Push
    vm.memory[1] = 0x05; // 5
    vm.memory[2] = 0x03; // Pop
    vm.memory[3] = 0x00; // no args
    vm.memory[4] = 0x01; // Add
    vm.memory[5] = 0x10; // B += A
    vm.memory[6] = 0x02; // Push
    vm.memory[7] = 0x02; // 2
    vm.memory[8] = 0x03; // Pop
    vm.memory[9] = 0x00; // no args
    vm.memory[10] = 0x01; // Add
    vm.memory[11] = 0x01; // B += A
    // A = (2 + 5), B = 5
    try vm.step();
    try vm.step();
    try vm.step();
    try vm.step();
    try vm.step();
    try vm.step();
}
