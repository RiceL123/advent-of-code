#!/usr/bin/env ruby

require 'json'

# Function to parse a section of lines into a machine structure
def section_to_machine(section_lines)
  lines = section_lines.split("\n")

  a_vec_components = lines[0].match(/X\+(\d+), Y\+(\d+)/).captures.map(&:to_i)
  b_vec_components = lines[1].match(/X\+(\d+), Y\+(\d+)/).captures.map(&:to_i)
  prize_pos = lines[2].match(/X=(\d+), Y=(\d+)/).captures.map(&:to_i)

  {
    a: a_vec_components,
    b: b_vec_components,
    prize: prize_pos
  }
end

A_COST = 3
B_COST = 1

def cheapest_win(machine, max_presses)
  greedy_moves = 0
  lazy_moves = 0

  greedy_vector = [0, 0]
  lazy_vector = [0, 0]

  # Choose greedy and lazy vectors based on cost-efficiency
  if machine[:a][0]**2 + machine[:a][1]**2 > (A_COST.to_f / B_COST) * (machine[:b][0]**2 + machine[:b][1]**2)
    greedy_vector = machine[:a]
    lazy_vector = machine[:b]
  else
    greedy_vector = machine[:b]
    lazy_vector = machine[:a]
  end

  target_prize = machine[:prize].dup

  for _ in 0..max_presses do
    x_component = target_prize[0].divmod(greedy_vector[0])
    y_component = target_prize[1].divmod(greedy_vector[1])

    if x_component[0] == y_component[0] && x_component[1] == 0 && y_component[1] == 0
      greedy_moves += x_component[0]
      break
    else
      target_prize[0] -= lazy_vector[0]
      target_prize[1] -= lazy_vector[1]
      lazy_moves += 1
    end

    # puts target_prize
    if target_prize[0] <= 0 || target_prize[1] <= 0
        return 0
    end
  end

  # Validate if the moves can reconstruct the prize position
  if lazy_moves * lazy_vector[0] + greedy_moves * greedy_vector[0] == machine[:prize][0] &&
     lazy_moves * lazy_vector[1] + greedy_moves * greedy_vector[1] == machine[:prize][1]
    if machine[:a] == greedy_vector
      return greedy_moves * A_COST + lazy_moves * B_COST
    else
      return greedy_moves * B_COST + lazy_moves * A_COST
    end
  end

  0
end

# Read the file and split it into sections
sections = File.read('./day13.txt')

part1 = 0
sections.split("\n\n").each do |section|
  machine = section_to_machine(section)
  part1 += cheapest_win(machine, 100)
end

puts part1

part2 = 0
sections.split("\n\n").each do |section|
  machine = section_to_machine(section)
  machine[:prize][0] += 10000000000000
  machine[:prize][1] += 10000000000000
  puts machine
  part2 += cheapest_win(machine, Float::INFINITY)
end

puts part2
