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
    var steps: MutableSet<Pair<Int, Int>>
)

fun get_graph(file_path: String) : Pair<MutableMap<Pair<Int, Int>, Int>, Pair<Pair<Int, Int>, Pair<Int, Int>>> {
    val graph: MutableMap<Pair<Int, Int>, Int> = mutableMapOf()
    var start: Pair<Int, Int> = Pair(-1, -1)
    var finish: Pair<Int, Int> = Pair(-1, -1)

    val text = File(file_path).readText().lines()
    for ((row, line) in text.withIndex()) {
        for ((col, char) in line.withIndex()) {
            when (char) {
                '.' -> graph[Pair(row, col)] = Int.MAX_VALUE
                'S' -> start = Pair(row, col)
                'E' -> {
                    finish = Pair(row, col)
                    graph[Pair(row, col)] = Int.MAX_VALUE
                }
            }
        }
    }

    return Pair(graph, Pair(start, finish))
}

fun dijkstra(graph: MutableMap<Pair<Int, Int>, Int>, start: Pair<Int, Int>, finish: Pair<Int, Int>): Int {
    var res = 0;
    val queue = PriorityQueue<Node>(compareBy { it.score })
    var visited: MutableSet<Pair<Int,Int>> = mutableSetOf()
    
    queue.add(Node(start, Pair(0, 1), 0)) // start facing east (0,1) & score 0

    while (queue.isNotEmpty()) {
        val curr = queue.poll()

        if (curr.pos == finish) {
            res = curr.score
        }

        val neighbour_directions = listOf(
            Pair(curr.direction, 1),
            Pair(Pair(curr.direction.second, -curr.direction.first), 1001),
            Pair(Pair(-curr.direction.second, curr.direction.first), 1001)  
        )

        for ((direction, score) in neighbour_directions) {
            val next_pos = Pair(curr.pos.first + direction.first, curr.pos.second + direction.second)
            val next_score = curr.score + score
            if (graph.containsKey(next_pos) && next_score < graph[next_pos]!!) {
                queue.add(Node(next_pos, direction, next_score))
                visited.add(next_pos)
                graph[next_pos] = next_score
            }
        }
    }

    return res;
}

fun backwards_bfs(graph: MutableMap<Pair<Int, Int>, Int>, finish: Pair<Int, Int>, min_score: Int): Int {
    var nodes = 2
    var queue: ArrayDeque<Node> = ArrayDeque(listOf(Node(finish, Pair(1, 0), min_score), Node(finish, Pair(0, -1), min_score)))
    var visited: MutableSet<Pair<Int,Int>> = mutableSetOf()

    while (queue.isNotEmpty()) {
        val curr = queue.removeFirst()

        val neighbour_directions = listOf(
            Pair(curr.direction, 1),
            Pair(Pair(curr.direction.second, -curr.direction.first), 1001),
            Pair(Pair(-curr.direction.second, curr.direction.first), 1001)  
        )

        for ((direction, score) in neighbour_directions) {
            val next_pos = Pair(curr.pos.first + direction.first, curr.pos.second + direction.second)
            val next_score = curr.score - score
            if (graph.containsKey(next_pos) && !visited.contains(next_pos) && (next_score == graph[next_pos]!! || next_score - 1000 == graph[next_pos]!!)) {
                queue.addLast(Node(next_pos, direction, next_score))
                visited.add(next_pos)
                nodes += 1
            }
        }
    }

    return nodes
}

fun main() {
    val (graph, positions) = get_graph("day16.txt")
    val (start, finish) = positions

    val min_score = dijkstra(graph, start, finish)
    println("part1: $min_score")

    val part2 = backwards_bfs(graph, finish, min_score)
    println("part2: $part2")
}
