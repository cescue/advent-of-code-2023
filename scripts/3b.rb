# frozen_string_literal: true

def number_at(line, index)
  return nil unless line && line[index] =~ /\d/

  number = line[index]

  start_index = index
  end_index = index

  until line[start_index - 1] !~ /\d/ || start_index - 1 < 0
    start_index -= 1
    number = line[start_index] + number
  end

  until line[end_index + 1] !~ /\d/ || end_index + 1 == line.length
    end_index += 1
    number = number + line[end_index]
  end

  { value: number.to_i, start_index: start_index, end_index: end_index} 
end

lines = File.readlines('3_input.txt')

sum_of_gear_ratios = 0

lines.each.with_index do |line, row|
  line.each_char.with_index do |char, col|
    next unless char == '*'

    adjacent_numbers = []

    if row > 0
      adjacent_numbers << number_at(lines[row - 1], col - 1)&.merge(row: row - 1)
      adjacent_numbers << number_at(lines[row - 1], col)&.merge(row: row - 1)
      adjacent_numbers << number_at(lines[row - 1], col + 1)&.merge(row: row - 1)
    end

    adjacent_numbers << number_at(line, col - 1)&.merge(row: row)
    adjacent_numbers << number_at(line, col + 1)&.merge(row: row)

    if row < lines.length - 1
      adjacent_numbers << number_at(lines[row + 1], col - 1)&.merge(row: row + 1)
      adjacent_numbers << number_at(lines[row + 1], col)&.merge(row: row + 1)
      adjacent_numbers << number_at(lines[row + 1], col + 1)&.merge(row: row + 1)
    end

    unique_adjacent_numbers = adjacent_numbers.compact.uniq

    next unless unique_adjacent_numbers.length == 2

    sum_of_gear_ratios += unique_adjacent_numbers.first[:value] * unique_adjacent_numbers.last[:value]
  end
end

puts sum_of_gear_ratios
