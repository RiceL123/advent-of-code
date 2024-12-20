import strutils, deques, sets, tables, sequtils, algorithm

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

    return (map(racetrack, proc(x: string): seq[char] = @x), start_pos, end_pos);

proc bfs(racetrack: seq[seq[char]], start_pos: (int, int), end_pos: (int, int)): (seq[(int, int)], Table[(int, int), int]) =
    var
        visited = initHashSet[(int, int)]()
        prev = initTable[(int, int), (int, int)]()
        queue = [start_pos].toDeque
        shortest_path = newSeq[(int, int)]()
        node_weights = initTable[(int, int), int]()
        picosecs = 0

    while queue.len > 0:
        let curr = queue.popFirst
        visited.incl(curr)
        node_weights[curr] = picosecs
        picosecs += 1;

        if curr == end_pos:
            shortest_path.add(end_pos)
            var backtrack = prev[curr]
            while backtrack != start_pos:
                shortest_path.add(backtrack)
                backtrack = prev[backtrack]
            shortest_path.add(start_pos)
            return (reversed(shortest_path), node_weights)

        for (d_row, d_col) in [(1, 0), (-1, 0), (0, 1), (0, -1)]:
            let neighbour = (curr[0] + d_row, curr[1] + d_col)
            if neighbour[0] >= 0 and neighbour[0] < racetrack.len and
                neighbour[1] >= 0 and neighbour[1] < racetrack[0].len and
                not visited.contains(neighbour) and
                racetrack[neighbour[0]][neighbour[1]] in ['.', 'E', '1', '2']:
                prev[neighbour] = curr
                queue.addLast(neighbour)

    return (reversed(shortest_path), node_weights)

var (racetrack, s_pos, e_pos) = get_racetrack("day20.txt")
let (shortest_path, node_weights) = bfs(racetrack, s_pos, e_pos)

proc num_cheats(max_taxicab_dist: int, min_saved_picos: int): int =
    var cheats = 0
    for i in 0..<shortest_path.len:
        let cheat_start = shortest_path[i]
        for j in (i + 1)..<shortest_path.len:
            let cheat_end = shortest_path[j]
            let taxicab_dist = abs(cheat_end[0] - cheat_start[0]) + abs(cheat_end[1] - cheat_start[1])
            let saved_picos = node_weights[cheat_end] - node_weights[cheat_start] - taxicab_dist
            if cheat_end != cheat_start and taxicab_dist <= max_taxicab_dist and saved_picos >= min_saved_picos:
                cheats += 1

    return cheats

echo "part1: ", num_cheats(2, 100)
echo "part2: ", num_cheats(20, 100)
