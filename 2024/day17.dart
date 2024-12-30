#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io';

void main() {
  var (registers, program) = get_registers_and_program("day17.txt");

  var output = [];
  for (int i = 0; i < program.length - 1; i += 2) {
    var opcode = program[i];
    var operand = program[i + 1];
    switch (opcode) {
      case 0:
        registers['A'] >>= combo(registers, operand);
      case 1:
        registers['B'] ^= operand;
      case 2:
        registers['B'] = combo(registers, operand) % 8;
      case 3:
        if (registers['A'] != 0) {
          i = operand - 2;
        }
      case 4:
        registers['B'] ^= registers['C'];
      case 5:
        output.add(combo(registers, operand) % 8);
      case 6:
        registers['B'] = registers['A'] >> combo(registers, operand);
      case 7:
        registers['C'] = registers['A'] >> combo(registers, operand);
    }
  }

  print("part1: " + output.join(","));
}

int combo(registers, int operand) {
  switch (operand) {
    case 4:
      return registers['A'];
    case 5:
      return registers['B'];
    case 6:
      return registers['C'];
    default:
      return operand;
  }
}

(Map<dynamic, dynamic>, List<int>) get_registers_and_program(file_path) {
  var [registers_str, program_str] = File(file_path)
      .readAsStringSync(encoding: ascii)
      .toString()
      .split("\n\n");

  var regs = Map.fromIterable(
      registers_str.split("\n").map((e) {
        var [reg, num] = e.substring(9).split(": ");
        return [reg, int.parse(num)];
      }),
      key: (x) => x[0],
      value: (x) => x[1]);

  var prog = program_str.trim().substring(9).split(",").map(int.parse).toList();

  return (regs, prog);
}
