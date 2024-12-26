package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:slice"

Wire :: struct {
    op: string,
    args: [2]string,
    result: string,
}

ResultWire :: struct{
    val: int,
    wire: string,
}

main :: proc() {
    wires, gates := get_wires_and_gates("day24.txt");
    fmt.print(gates);
    // fmt.printf("wires: %v\n", wires);

    results := [dynamic]ResultWire{};

    // not all dependencies resolved before we go into this statement
    for wire in wires {
        switch wire.op {
            case "AND":
                append(&results, ResultWire {
                    val = gates[wire.args[0]] & gates[wire.args[1]],
                    wire = wire.result,
                });
                gates[wire.result] = gates[wire.args[0]] & gates[wire.args[1]];
            case "OR":
                append(&results, ResultWire {
                    val = gates[wire.args[0]] | gates[wire.args[1]],
                    wire = wire.result,
                });
                gates[wire.result] = gates[wire.args[0]] | gates[wire.args[1]];
            case "XOR":
                append(&results, ResultWire {
                    val = gates[wire.args[0]] ~ gates[wire.args[1]],
                    wire = wire.result,
                });
                gates[wire.result] = gates[wire.args[0]] ~ gates[wire.args[1]];
            case:
                fmt.printf("wtf?: %v", wire);
                os.exit(1);
        }
    }

    fmt.print(gates);
    // res := results[:]
    res := slice.filter(results[:], proc(x: ResultWire) -> bool {
        return strings.starts_with(x.wire, "z");
    });

    // fmt.print(res);

    slice.sort_by(res, proc(i: ResultWire, j: ResultWire) -> bool {
        // if i.wire[0] == j.wire[0] {
        //     return strconv.atoi(i.wire[1:]) > strconv.atoi(j.wire[1:]);
        // }
        // return i.wire[0] < j.wire[0];
        return i.wire < j.wire;
    });

    fmt.print(res);

    fmt.print("\n");
    bits := slice.mapper(res, proc(x: ResultWire) -> string {
        buf: [64]u8 = --- // tell the compiler to not 0 initialize
        str := strconv.itoa(buf[:], x.val);
        // fmt.printf("int: %v, str: %s\n", x.val, str);
        fmt.printf("%d", x.val);
        return string(str[:]);
    });
    fmt.print("\n");
    // fmt.printf("bits: %v\n", bits);
    bit_string := strings.concatenate(bits);

    // fmt.printf("bit_string: %v\n", bit_string);

    part1, ok := strconv.parse_int(bit_string, base = 2);
    if !ok { os.exit(1) }

    // fmt.printf("part1: %d\n", part1);
}

get_wires_and_gates :: proc(file_path: string) -> ([]Wire, map[string]int) {
    file_content, ok := os.read_entire_file(file_path);
    // fmt.printf("%s", file_content);

    parts := strings.split(string(file_content), "\n\n");

    wires := map[string]int{};
    context.user_ptr = &wires;
    for wire_line in strings.split(parts[0], "\n") {
        wire_parts := strings.split(wire_line, ": ");
        key := strings.clone(wire_parts[0]);
        wires[key] = strconv.atoi(wire_parts[1]);
    }

    gates := [dynamic]Wire{};
    for gate_line in strings.split(parts[1], "\n") {
        gate_parts := strings.split(gate_line, " -> ");
        operation := strings.split(gate_parts[0], " ");
        gate := Wire {
            op = strings.clone(operation[1]),
            args = [2]string{strings.clone(operation[2]), strings.clone(operation[0])},
            result = gate_parts[1],
        };
        append(&gates, gate);
    }

    sorted_gates := gates[:];
    slice.sort_by(sorted_gates, proc(a: Wire, b: Wire) -> bool {
        get_dependency_score :: proc(w: Wire, wires: ^map[string]int) -> int {
            score := 1;
            if w.args[0] in wires && w.args[1] in wires {
                score = 2;
            } else if !(w.args[0] in wires) && !(w.args[1] in wires) {
                score = 0;
            }
            return score;
        };
        
        wires := (^map[string]int)(context.user_ptr);
        return get_dependency_score(a, wires) > get_dependency_score(b, wires);
    });

    // fmt.print(sorted_gates);
    return sorted_gates, wires;
}

// part 2?
