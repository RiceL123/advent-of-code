#!/usr/bin/env crystal

codes = get_codes("day21.txt")

part1 = codes
  .map { |(code, numeric)| shortest_sequence(code, 2) * numeric }
  .sum

puts "part1: #{part1}"

def get_codes(file_path)
  content = File.read(file_path).split("\n")
  content.map { |code| {code, code[0, 3].to_i} }
end

class Pad
  NUM = {
    {0, 0} => '7', {0, 1} => '8', {0, 2} => '9',
    {1, 0} => '4', {1, 1} => '5', {1, 2} => '6',
    {2, 0} => '1', {2, 1} => '2', {2, 2} => '3',
                   {3, 1} => '0', {3, 2} => 'A',
  }

  NUM_POS = NUM.invert

  KEY = {
                   {0, 1} => '^', {0, 2} => 'A',
    {1, 0} => '<', {1, 1} => 'v', {1, 2} => '>',
  }

  KEY_POS = KEY.invert
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

def optimal_sequence(pad : Hash(Tuple(Int, Int), Char), pad_pos : Hash(Char, Tuple(Int, Int)), code : String) : String
  keypad_sequence = ""
  i = 0
  target = pad_pos[code.char_at(i)]
  start = pad_pos['A']

  curr = start
  while i < code.size
    target = pad_pos[code.char_at(i)]
    opt = pad.has_key?({curr[0], target[1]}) ? {curr[0], target[1]} : {target[0], curr[1]}

    # move to the optimal intermediary and then target
    keypad_sequence += move_opt(curr, opt) + move_opt(opt, target) + "A"

    curr = target
    i += 1
  end

  keypad_sequence
end

def keypad_sequence_len(sequence : String) : Int
  a = optimal_sequence(Pad::KEY, Pad::KEY_POS, sequence)
  b = optimal_sequence(Pad::KEY, Pad::KEY_POS, a)

  puts "#{b}"
  return b.size
end

def shortest_sequence(code, keypads)
  sequence = optimal_sequence(Pad::NUM, Pad::NUM_POS, code)
  print "#{code}: "

  keypad_sequence_len(sequence)
end
