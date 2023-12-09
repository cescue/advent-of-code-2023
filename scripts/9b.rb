# frozen_string_literal: true

def next_in_sequence(sequence)
  predictors = sequence.each_cons(2).map { |x| x.first - x.last }

  return predictors.last if sequence.first.zero? && sequence.uniq.count == 1

  sequence.last - next_in_sequence(predictors)
end

sum_of_extrapolated_values = 0

File.foreach('9_input.txt') do |line|
  sequence = line.chomp.split(' ').map(&:to_i).reverse
  sum_of_extrapolated_values += next_in_sequence(sequence)
end

puts sum_of_extrapolated_values
