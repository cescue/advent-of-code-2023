# frozen_string_literal: true

total_points = 0

File.foreach('4_input.txt') do |line|
  picked_numbers, winning_numbers = line.sub(/Card\s+\d+:/, '').split(' | ')

  picked_numbers = picked_numbers.split(' ').map(&:to_i)
  winning_numbers = winning_numbers.split(' ').map(&:to_i)

  total_winners = picked_numbers.intersection(winning_numbers).length

  next if total_winners.zero?

  total_points += 2**(total_winners - 1)
end

puts total_points
