import java.io.File
import java.util.PriorityQueue

data class Node(
    val pos: Pair<Int, Int>,
    val direction: Pair<Int, Int>,
    val score: Int
)

data class StepNode(
    val pos: Pair<Int, Int>,
    val direction: Pair<Int, Int>,
    val score: Int,
    val steps: MutableSet<Pair<Int, Int>>
)

fun get_graph(file_path: String) : Pair<MutableMap<Pair<Int, Int>, Int>, Pair<Pair<Int, Int>, Pair<Int, Int>>> {
    val graph: MutableMap<Pair<Int, Int>, Int> = mutableMapOf()
    var start: Pair<Int, Int> = Pair(-1, -1)
    var finish: Pair<Int, Int> = Pair(-1, -1)

    val text = File(file_path).readText().lines()
    for ((row, line) in text.withIndex()) {
        for ((col, char) in line.withIndex()) {
            when (char) {
                '.' -> graph[Pair(row, col)] = -1
                'S' -> start = Pair(row, col)
                'E' -> {
                    finish = Pair(row, col)
                    graph[Pair(row, col)] = -1
                }
            }
        }
    }

    return Pair(graph, Pair(start, finish))
}

fun dijkstra(graph: MutableMap<Pair<Int, Int>, Int>, start: Pair<Int, Int>, finish: Pair<Int, Int>): Int {
    val queue = PriorityQueue<Node>(compareBy { it.score })
    var visited: MutableSet<Pair<Pair<Int,Int>, Pair<Int,Int>>> = mutableSetOf()

    queue.add(Node(start, Pair(0, 1), 0)) // start facing east (0,1) & score 0

    while (queue.isNotEmpty()) {
        val curr = queue.poll()

        if (curr.pos == finish) {
            return curr.score;
        }

        // try move forward position
        val forward: Pair<Int, Int> = Pair(curr.pos.first + curr.direction.first, curr.pos.second + curr.direction.second);
        if (graph.containsKey(forward) && !visited.contains(Pair(forward, curr.direction))) {
            queue.add(Node(forward, curr.direction, curr.score + 1))
            visited.add(Pair(forward, curr.direction))
        }

        // try rotate if theres a space there
        val perpendicular_directions = listOf(
            Pair(curr.direction.second, -curr.direction.first),
            Pair(-curr.direction.second, curr.direction.first)
        )
        for (direction in perpendicular_directions) {
            val next_pos = Pair(curr.pos.first + direction.first, curr.pos.second + direction.second)
            if (graph.containsKey(next_pos) && !visited.contains(Pair(curr.pos, direction))) {
                queue.add(Node(curr.pos, direction, curr.score + 1000))
                visited.add(Pair(curr.pos, direction))
            }
        }
    }

    return 0;
}

fun dfs(graph: MutableMap<Pair<Int, Int>, Int>, finish: Pair<Int, Int>, max_score: Int, curr: StepNode): MutableSet<Pair<Int, Int>> {
    if (curr.pos == finish) {
        println("finished! $curr")
        return curr.steps
    }

    if (curr.score >= max_score) {
        return mutableSetOf() // empty set
    }

    var tiles: MutableSet<Pair<Int, Int>> = mutableSetOf()
    // try move forward position
    val forward: Pair<Int, Int> = Pair(curr.pos.first + curr.direction.first, curr.pos.second + curr.direction.second);
    if (graph.containsKey(forward)) {
        curr.steps.add(forward)
        tiles.addAll(dfs(graph, finish, max_score, StepNode(forward, curr.direction, curr.score + 1, curr.steps)))
    }

    // try rotate if theres a space there
    val perpendicular_directions = listOf(
        Pair(curr.direction.second, -curr.direction.first),
        Pair(-curr.direction.second, curr.direction.first)
    )
    for (direction in perpendicular_directions) {
        val next_pos = Pair(curr.pos.first + direction.first, curr.pos.second + direction.second)
        if (graph.containsKey(next_pos)) {
            tiles.addAll(dfs(graph, finish, max_score, (StepNode(curr.pos, direction, curr.score + 1000, curr.steps))))
        }
    }

    return tiles;
}

fun main() {
    val (graph, positions) = get_graph("day16.txt")
    val (start, finish) = positions

    val min_score = dijkstra(graph, start, finish)
    println("part1: $min_score")

    // although dfs correctly finds all paths to finish, the different paths are
    // not optimal for some reason
    val dfs_score = dfs(graph, finish, min_score, StepNode(start, Pair(0, 1), 0, mutableSetOf(start))).size
    println("part2: $dfs_score")
}
