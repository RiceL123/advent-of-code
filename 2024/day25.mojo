#!/usr/bin/env mojo

def get_keys_locks(file_path: String) -> (List[List[Int]], List[List[Int]]):
    var keys = List[List[Int]]()
    var locks = List[List[Int]]()
    
    var content = open(file_path, "r").read()
    var schematics = content.split("\n\n")
    
    for schematic in schematics:

        var is_key = False
        if schematic[].startswith("#####"):
            is_key = True

        var lines = schematic[].split("\n")
        var num_columns = len(lines[0])
        var transposed = List[List[String]]()
        for _ in range(num_columns):
            transposed.append(List[String]())
        
        for line in lines:
            for idx in range(len(line[])):
                transposed[idx].append(line[][idx])
    
        var c = "."
        if is_key:
            c = '#'

        var pin_lengths = List[Int]()
        for pin in transposed:
    
            var pin_length = 0
            for char in pin[]:
                if char[] == c:
                    pin_length += 1
                else:
                    break
            if is_key:
                pin_lengths.append(pin_length - 1)
            else:
                pin_lengths.append(5 - (pin_length - 1))
                
        if is_key:
            keys.append(pin_lengths)
        else:
            locks.append(pin_lengths)
    
    return (keys, locks)

def main():
    keys, locks = get_keys_locks("day25.txt")

    var part1 = 0
    for lock in locks:
        for key in keys:
            var valid = True
            for i in range(len(key[])):
                if key[][i] + lock[][i] > 5:
                    valid = False
                    break
            if valid:
                part1 += 1
    
    print("part1: ", part1)

# Wrote python program first thinking I would be able to 
# easily translate it to mojo. Turns out mojo is too immature
# and takes 3 times the amount of lines 😠

#!/usr/bin/env python3

# def get_keys_locks(file_path: str) -> tuple[list[str], list[str]]:
#     keys = []
#     locks = []
#     [
#         (keys if schematic.startswith("#####") else locks).append(
#             [len("".join(pin).replace('#' if pin[0] == "#####" else '.', '')) - 1 for pin in list(zip(*schematic.split("\n")))]
#         )
#         for schematic in open(file_path, "r").read().split("\n\n")
#     ]

#     return keys, locks


# if __name__ == "__main__":
#     keys, locks = get_keys_locks("day25.txt")

#     part1 = sum(
#         [
#             1 if all([key_pin + lock_hole <= 5 for key_pin, lock_hole in zip(key, lock)]) else 0 
#             for lock in locks 
#             for key in keys
#         ]
#     )
    
#     print(f"part1: {part1}")
