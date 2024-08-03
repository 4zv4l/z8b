const std = @import("std");
const Cpu8 = @import("cpu.zig");
const Fmt = @import("fmt.zig");

pub fn main() !void {
    var vm = Cpu8.init();
    vm.memory[0] = 0x02; // Push 5
    vm.memory[1] = 0x05;
    vm.memory[2] = 0x03; // Pop A
    vm.memory[3] = 0x00;
    vm.memory[4] = 0x01; // Add B A
    vm.memory[5] = 0x10;
    vm.memory[6] = 0x02; // Push 2
    vm.memory[7] = 0x02;
    vm.memory[8] = 0x03; // Pop B
    vm.memory[9] = 0x01;
    vm.memory[10] = 0x01; // Add A B
    vm.memory[11] = 0x01;
    // A = (2 + 5), B = 5
    try vm.step();
    try vm.step();
    try vm.step();
    try vm.step();
    try vm.step();
    try vm.step();
}
