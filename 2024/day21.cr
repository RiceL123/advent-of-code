#!/usr/bin/env crystal

codes = get_codes("day21.txt")

part1 = codes
  .map { |(code, numeric)| shortest_sequence(code) * numeric }
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

  KEY = {
                   {0, 1} => '^', {0, 2} => 'A',
    {1, 0} => '<', {1, 1} => 'v', {1, 2} => '>',
  }
end

def shortest_sequence(code)
  puts Pad::NUM
  puts Pad::KEY
  cache = {}

  1
end
