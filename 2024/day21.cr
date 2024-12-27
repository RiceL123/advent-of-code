#!/usr/bin/env crystal

def get_codes(file_path)
  content = File.read(file_path).split("\n")
  content.map { |code| {code, code[0, 3].to_i} }
end

class Pad
  NUM = {
    '7' => {0, 0}, '8' => {0, 1}, '9' => {0, 2},
    '4' => {1, 0}, '5' => {1, 1}, '6' => {1, 2},
    '1' => {2, 0}, '2' => {2, 1}, '3' => {2, 2},
                   '0' => {3, 1}, 'A' => {3, 2},
  }

  KEY = {
                   '^' => {0, 1}, 'A' => {0, 2},
    '<' => {1, 0}, 'v' => {1, 1}, '>' => {1, 2},
  }
end

class Cache
  SEQ = Hash(Tuple(String, Int32), Int64).new
  DIST = Hash(Tuple(Char, Char, Int32), Int64).new
end

def move_opt(a : Tuple(Int, Int), b : Tuple(Int, Int)) : String
  seq = ""
  if a[1] - b[1] > 0
    seq += "<" * (a[1] - b[1])
  else
    seq += ">" * (b[1] - a[1])
  end

  if a[0] - b[0] > 0
    seq += "^" * (a[0] - b[0])
  else
    seq += "v" * (b[0] - a[0])
  end

  seq
end

def sequences(start : Char, finish : Char, pad = Pad::KEY) : Set
  if Pad::NUM.has_key?(start) && Pad::NUM.has_key?(finish)
    pad = Pad::NUM
  end

  [{pad[finish][0], pad[start][1]}, {pad[start][0], pad[finish][1]}]
    .reject { |x| !pad.invert.has_key?(x) }
    .map { |x| move_opt(pad[start], x) + move_opt(x, pad[finish]) + "A" }
    .to_set
end

def shortest_sequence(seq : String, depth : Int, length : Int64 = Int64.new(0)) : Int64
  if depth == 0
    return seq.size.to_i64
  end

  length += Cache::SEQ.fetch({seq, depth}) {
    Cache::SEQ[{seq, depth}] = (0..seq.size - 1).map { |i|
      Cache::DIST.fetch({seq.char_at(i - 1), seq.char_at(i), depth}) {
        Cache::DIST[{seq.char_at(i - 1), seq.char_at(i), depth}] = sequences(seq.char_at(i - 1), seq.char_at(i))
        .map { |x| shortest_sequence(x, depth - 1) }
        .min
      }
    }.sum
  }

  length
end

codes = get_codes("day21.txt")

part1 = codes
  .map { |(code, numeric)| (shortest_sequence(code, 3) * numeric) }
  .sum

puts "part1: #{part1}"

part2 = codes
  .map { |(code, numeric)| (shortest_sequence(code, 26) * numeric) }
  .sum

puts "part2: #{part2}"
