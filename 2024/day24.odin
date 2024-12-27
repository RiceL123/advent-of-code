#!/usr/bin/env -S odin run "day24.odin" -file

package main

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

Wire :: struct {
	op:     string,
	args:   [2]string,
	result: string,
}

ResultWire :: struct {
	val:  int,
	wire: string,
}

main :: proc() {
	wires, gates := get_wires_and_gates("day24.txt")

	fmt.printf("part1: %d\n", part1(wires, &gates))
	fmt.printf("part2: %s\n", part2(wires, &gates, "z45"))
}

get_wires_and_gates :: proc(file_path: string) -> (map[string]Wire, map[string]int) {
	file_content, ok := os.read_entire_file(file_path)
	parts := strings.split(string(file_content), "\n\n")

	wires := map[string]int{}
	context.user_ptr = &wires
	for wire_line in strings.split(parts[0], "\n") {
		wire_parts := strings.split(wire_line, ": ")
		key := strings.clone(wire_parts[0])
		wires[key] = strconv.atoi(wire_parts[1])
	}

	gates := map[string]Wire{}
	for gate_line in strings.split(parts[1], "\n") {
		gate_parts := strings.split(gate_line, " -> ")
		operation := strings.split(gate_parts[0], " ")
		gate := Wire {
			op     = strings.clone(operation[1]),
			args   = [2]string{strings.clone(operation[2]), strings.clone(operation[0])},
			result = strings.clone(gate_parts[1]),
		}
		gates[strings.clone(gate_parts[1])] = gate
	}

	return gates, wires
}

part1 :: proc(wires: map[string]Wire, gates: ^map[string]int) -> int {
	results := [dynamic]ResultWire{}
	for key, value in wires {
		append(&results, get_wire_values(value, wires, gates))
	}

	res := slice.filter(results[:], proc(x: ResultWire) -> bool {
		return strings.starts_with(x.wire, "z")
	})

	slice.sort_by(res, proc(i: ResultWire, j: ResultWire) -> bool {
		return i.wire > j.wire
	})

	bits := slice.mapper(res, proc(x: ResultWire) -> string {return fmt.aprint(x.val)})
	bit_string := strings.concatenate(bits)

	part1, ok := strconv.parse_int(bit_string, base = 2)
	if !ok {os.exit(1)}

	return part1
}

get_wire_values :: proc(wire: Wire, wires: map[string]Wire, gates: ^map[string]int) -> ResultWire {
	l := gates[wire.args[0]]
	if !(wire.args[0] in gates) {
		a := get_wire_values(wires[wire.args[0]], wires, gates)
		l = a.val
	}

	r := gates[wire.args[1]]
	if !(wire.args[1] in gates) {
		a := get_wire_values(wires[wire.args[1]], wires, gates)
		r = a.val
	}

	val := 0
	switch wire.op {
	case "AND":
		val = l & r
	case "OR":
		val = l | r
	case "XOR":
		val = l ~ r
	case:
		fmt.printf("wtf?: %v", wire)
		os.exit(1)
	}

	gates[strings.clone(wire.result)] = val
	return ResultWire{val = val, wire = wire.result}
}

part2 :: proc(wires: map[string]Wire, gates: ^map[string]int, zMAX: string) -> string {
	incorrect := [dynamic]string{}
	for key, wire in wires {
		if key[0] == 'z' && wire.op != "XOR" && key != zMAX {
			append(&incorrect, key)
		} else if (wire.op == "XOR" &&
			   !(strings.contains_rune("xyz", rune(key[0]))) &&
			   !(strings.contains_rune("xyz", rune(wire.args[0][0]))) &&
			   !(strings.contains_rune("xyz", rune(wire.args[1][0])))) {
			append(&incorrect, key)
		} else if (wire.op == "AND" && wire.args[0] != "x00" && wire.args[1] != "x00") {
			for sub_key, sub_wire in wires {
				if ((key == sub_wire.args[0] || key == sub_wire.args[1]) && sub_wire.op != "OR") {
					append(&incorrect, key)
					break;
				}
			}
		} else if (wire.op == "XOR") {
			for sub_key, sub_wire in wires {
				if ((key == sub_wire.args[0] || key == sub_wire.args[1]) && sub_wire.op == "OR") {
					append(&incorrect, key)
					break;
				}
			}
		}
	}

	slice.sort(incorrect[:]);
	return strings.join(incorrect[:], ",")
}
