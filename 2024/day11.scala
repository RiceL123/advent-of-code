// #!/usr/bin/env scala
//> using scala 3.6.2
//> using toolkit default

import scala.io.Source
import scala.collection.mutable

def get_stones(file_path: String): Array[Int] =
  Source.fromFile(file_path).getLines().next().split(" ").map(_.toInt)

var cache = mutable.Map[(BigInt, Int), BigInt]()
def get_length(stone: BigInt, iteration: Int): BigInt =
  val key = (stone, iteration)

  if iteration == 0 then
    cache.update(key, 1)
    return 1
  
  cache.getOrElseUpdate(key, {
    if stone == 0 then
      get_length(1, iteration - 1)
    else if stone.toString.length % 2 == 0 then
      val stoneStr = stone.toString
      val mid = stoneStr.length / 2
      val left = stoneStr.substring(0, mid).toInt
      val right = stoneStr.substring(mid).toInt
      get_length(left, iteration - 1) + get_length(right, iteration - 1)
    else
      get_length(stone * 2024, iteration - 1)
  })

@main
def day11(): Unit =
  val stones = get_stones("day11.txt")

  val part1 = stones.map(get_length(_, 25)).sum
  val part2 = stones.map(get_length(_, 75)).sum

  println(s"part 1: $part1")
  println(s"part 2: $part2")
