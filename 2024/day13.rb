#!/usr/bin/env ruby

require 'matrix'

def section_to_machine(section_lines)
  button_a, button_b, prize = section_lines.split("\n")

  a_vec_components = button_a.match(/X\+(\d+), Y\+(\d+)/).captures.map(&:to_i)
  b_vec_components = button_b.match(/X\+(\d+), Y\+(\d+)/).captures.map(&:to_i)
  prize_pos = prize.match(/X=(\d+), Y=(\d+)/).captures.map(&:to_i)

  {
    a: a_vec_components,
    b: b_vec_components,
    prize: prize_pos
  }
end

A_COST = 3
B_COST = 1
def cheapest_win(machine, max_presses)
  # assume there is only one solution to the system of 2 linear equations
  # machine[:a][0] * a_presses + machine[:b][0] * b_presses = machine[:prize][0]
  # machine[:a][1] * a_presses + machine[:b][1] * b_presses = machine[:prize][1]

  button_coefficients = Matrix[[machine[:a][0], machine[:b][0]], [machine[:a][1], machine[:b][1]]]
  prize = Matrix[[machine[:prize][0]], [machine[:prize][1]]]

  a_presses, b_presses = (button_coefficients.inverse * prize).to_a.flatten

  if a_presses % 1 == 0 && b_presses % 1 == 0
    return (a_presses * A_COST + b_presses * B_COST).to_i
  end

  return 0
end

sections = File.read('./day13.txt')

part1 = 0
sections.split("\n\n").each do |section|
  machine = section_to_machine(section)
  part1 += cheapest_win(machine, 100)
end
puts "part1: #{part1}"

part2 = 0
sections.split("\n\n").each do |section|
  machine = section_to_machine(section)
  machine[:prize][0] += 10000000000000
  machine[:prize][1] += 10000000000000
  part2 += cheapest_win(machine, Float::INFINITY)
end
puts "part2: #{part2}"
