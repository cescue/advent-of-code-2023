# frozen_string_literal: true

cards = {}

File.foreach('4_input.txt') do |line|
  picked_numbers, winning_numbers = line.sub(/Card\s+(\d+):/, '').split(' | ')

  card_number = $1.to_i

  picked_numbers = picked_numbers.split(' ').map(&:to_i)
  winning_numbers = winning_numbers.split(' ').map(&:to_i)

  total_winners = picked_numbers.intersection(winning_numbers).length

  cards[card_number] ||= { instances: 1, total_winners: total_winners }
end

cards.each_key do |card_number|
  cards[card_number][:instances].times do |instance|
    cards[card_number][:total_winners].times do |i|
      cards[card_number + i + 1][:instances] += 1
    end
  end  
end

puts cards.values.map { |card| card[:instances] }.sum
