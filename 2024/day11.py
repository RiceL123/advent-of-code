#!/usr/bin/env python3

def file_to_stones(file_path: str):
    return [int(num) for num in open(file_path).readline().split(" ")]

cache = {}
def get_length(stone, iteration):
    key = (stone, iteration)

    if iteration == 0:
        cache[key] = 1
        return 1

    if not cache.get(key):
        if stone == 0:
            length = get_length(1, iteration - 1)
        elif len(str(stone)) % 2 == 0:
            stone_str = str(stone)
            mid = len(stone_str) // 2
            length = get_length(int(stone_str[mid:]), iteration - 1) + get_length(int(stone_str[:mid]), iteration - 1)
        else:
            length = get_length(stone * 2024, iteration - 1)

        cache[key] = length
        return length
    else:
        return cache[key]


if __name__ == "__main__":
    stones = file_to_stones("day11.txt")

    print(f'part 1: {sum(map(lambda stone: get_length(stone, 25), stones))}')
    print(f'part 2: {sum(map(lambda stone: get_length(stone, 75), stones))}')
