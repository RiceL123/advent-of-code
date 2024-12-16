#!/usr/bin/env python3

def get_map_moves(file_path: str):
    map, moves = open(file_path, 'r').read().split("\n\n")

    map = [list(row) for row in map.split('\n')]
    start_position = next((row, col) for row, row_data in enumerate(map) for col, cell in enumerate(row_data) if cell == '@')

    return start_position, map, moves

def get_connected_components(map, pos, direction):
    connected_componets = set()

    stack = [pos]
    while stack:
        curr = stack.pop()
        if curr in stack or (curr[0], curr[1], map[curr[0]][curr[1]]) in connected_componets:
            continue

        if map[curr[0]][curr[1]] == '.':
            continue
        elif map[curr[0]][curr[1]] == '#':
            return []
        elif map[curr[0]][curr[1]] == 'O':
            connected_componets.add((curr[0], curr[1], map[curr[0]][curr[1]]))
            stack.append((curr[0] + direction[0], curr[1] + direction[1]))
        elif map[curr[0]][curr[1]] in ['[', ']'] and direction[0] == 0:
            # horizontal movements, skip the matching box end
            connected_componets.add((curr[0], curr[1], map[curr[0]][curr[1]]))
            connected_componets.add((curr[0], curr[1] + direction[1], map[curr[0]][curr[1] + direction[1]]))
            stack.append((curr[0], curr[1] + direction[1] * 2))
        elif map[curr[0]][curr[1]] in ['[', ']'] and direction[1] == 0:
            # vertical movements, append both sides of the box
            connected_componets.add((curr[0], curr[1], map[curr[0]][curr[1]]))
            stack.append((curr[0] + direction[0], curr[1]))
            if map[curr[0]][curr[1]] == '[':
                stack.append((curr[0], curr[1] + 1))
            elif map[curr[0]][curr[1]] == ']':
                stack.append((curr[0], curr[1] - 1))

    return connected_componets

def move_robot(map, pos, direction):
    new_pos = (pos[0] + direction[0], pos[1] + direction[1])
    if map[new_pos[0]][new_pos[1]] == '#':
        return pos
    elif map[new_pos[0]][new_pos[1]] == '.':
        map[pos[0]][pos[1]] = '.'
        map[new_pos[0]][new_pos[1]] = '@'
        return new_pos
    elif map[new_pos[0]][new_pos[1]] in ['O', '[', ']']:
        boxes_to_move = get_connected_components(map, new_pos, direction)
        if boxes_to_move:
            # remove all boxes from prev location
            for box in boxes_to_move:
                map[box[0]][box[1]] = '.'
            # move all boxes to new location
            for box in boxes_to_move:
                map[box[0] + direction[0]][box[1] + direction[1]] = box[2]

            map[pos[0]][pos[1]] = '.'
            map[new_pos[0]][new_pos[1]] = '@'
            return new_pos

    return pos

def sum_coordinates(pos, map, moves):
    move_table = {'^': (-1, 0), '>': (0, 1), 'v': (1, 0), '<': (0, -1)}
    for move in moves:
        if move != '\n':
            pos = move_robot(map, pos, move_table[move])

    return sum(100 * row + col for row, row_data in enumerate(map) for col, cell in enumerate(row_data) if cell in ['O', '['])

if __name__ == "__main__":

    start_pos, map, moves = get_map_moves("day15.txt")
    print(f'part1: {sum_coordinates(start_pos, map, moves)}')

    start_pos, map, moves = get_map_moves("day15.txt")
    start_pos = (start_pos[0], start_pos[1] * 2)
    translation = {'O': '[]', '@': '@.', '.': '..', '#': '##'}
    for i, row in enumerate(map):
        for j, col in enumerate(row):
            map[i][j] = translation[col]
        map[i] = [a for x in map[i] for a in x] # flatten

    print(f'part2: {sum_coordinates(start_pos, map, moves)}')
