#!/usr/bin/env nim

import strutils, deques, sets, tables

proc get_racetrack(file_path: string): (seq[seq[char]], (int, int), (int, int)) =
    let racetrack = readFile(file_path).split("\n")

    var
        start_pos = (0, 0)
        end_pos = (0, 0)

    for row, line in racetrack:
        for col, c in line:
            if c == 'S':
                start_pos = (row, col)
            if c == 'E':
                end_pos = (row, col)

    var mutable_racetrack: seq[seq[char]] = @[]  # mutable racetrack
    for line in racetrack:
        mutable_racetrack.add(@line)

    return (mutable_racetrack, start_pos, end_pos);

proc bfs(racetrack: seq[seq[char]], start_pos: (int, int), end_pos: (int, int)): seq[(int, int)] =
    var
        visited = initHashSet[(int, int)]()
        prev = initTable[(int, int), (int, int)]()
        queue = [start_pos].toDeque
        shortest_path = @[end_pos]

    while queue.len > 0:
        let curr = queue.popFirst
        # echo curr
        visited.incl(curr)

        if curr == end_pos:
            # backtrack
            var backtrack = prev[curr]
            while backtrack != start_pos:
                shortest_path.add(backtrack)
                backtrack = prev[backtrack]

            return shortest_path

        for (d_row, d_col) in [(1, 0), (-1, 0), (0, 1), (0, -1)]:
            let neighbour = (curr[0] + d_row, curr[1] + d_col)
            if neighbour[0] >= 0 and neighbour[0] < racetrack.len and
                neighbour[1] >= 0 and neighbour[1] < racetrack[0].len and
                not visited.contains(neighbour) and
                racetrack[neighbour[0]][neighbour[1]] in ['.', 'E', '1', '2']:
                prev[neighbour] = curr
                queue.addLast(neighbour)

    return shortest_path

var (racetrack, s_pos, e_pos) = get_racetrack("day20.txt")

# try every permutation of cheats that is neighbouring the path?
# echo s_pos
# echo e_pos

let shortest_path = bfs(racetrack, s_pos, e_pos)

var cheats = 0
var table: OrderedTable[int, int]

var visited_cheats = initHashSet[(int, int)]()
# for each position on the shortest path, add a cheat in NESW
for (row, col) in shortest_path:
    # echo row, ", ", col

    for (d_row, d_col) in [(1, 0), (-1, 0), (0, 1), (0, -1)]:
        var racetrack_cheat = racetrack
        let
            cheat1 = (row + d_row, col + d_col)
            cheat2 = (row + d_row * 2, col + d_col * 2)

        if cheat2[0] >= 0 and cheat2[0] < racetrack_cheat.len and
            cheat2[1] >= 0 and cheat2[1] < racetrack_cheat[0].len and
            not (cheat1 in visited_cheats) and
            racetrack_cheat[cheat1[0]][cheat1[1]] == '#' and
            racetrack_cheat[cheat2[0]][cheat2[1]] in ['.' , 'E']:

            racetrack_cheat[cheat1[0]][cheat1[1]] = '1'
            racetrack_cheat[cheat2[0]][cheat2[1]] = '2'

            visited_cheats.incl(cheat1)
            visited_cheats.incl(cheat2)

            let cheat_path = bfs(racetrack_cheat, s_pos, e_pos)
            if shortest_path.len - cheat_path.len >= 100:

                if (shortest_path.len - cheat_path.len in table):
                    table[shortest_path.len - cheat_path.len] += 1
                else:
                    table[shortest_path.len - cheat_path.len] = 1
                cheats += 1

echo "part1: ", cheats

