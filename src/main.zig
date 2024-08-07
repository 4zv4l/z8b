const std = @import("std");
const Cpu8 = @import("cpu.zig");
const Fmt = @import("fmt.zig");

pub fn main() !void {
    var vm = Cpu8.init();
    vm.memory[0] = 0x03; // Push 5
    vm.memory[1] = 0x05;
    vm.memory[2] = 0x04; // Pop A
    vm.memory[3] = 0x00;
    vm.memory[4] = 0x01; // Add B A
    vm.memory[5] = 0x10;
    vm.memory[6] = 0x03; // Push 2
    vm.memory[7] = 0x02;
    vm.memory[8] = 0x04; // Pop B
    vm.memory[9] = 0x01;
    vm.memory[10] = 0x01; // Add A B
    vm.memory[11] = 0x01;
    vm.memory[12] = 0x03; // Push 7
    vm.memory[13] = 0x07;
    vm.memory[14] = 0x04; // Pop C
    vm.memory[15] = 0x02;
    vm.memory[16] = 0x07; // Cmp A C
    vm.memory[17] = 0x02;
    vm.memory[18] = 0x05; // Jmpz 30
    vm.memory[19] = 0x1e;
    vm.memory[20] = 0x03; // Push 1
    vm.memory[21] = 0x01;
    vm.memory[22] = 0x04; // Pop B
    vm.memory[23] = 0x01;
    vm.memory[30] = 0x03; // Push 33
    vm.memory[31] = 0x21;
    vm.memory[32] = 0x04; // Pop B
    vm.memory[33] = 0x01;
    try vm.step();
    try vm.step();
    try vm.step();
    try vm.step();
    try vm.step();
    try vm.step();
    try vm.step();
    try vm.step();
    try vm.step();
    try vm.step();
    try vm.step();
}
