# frozen_string_literal: true

class EngineFixer
  attr_reader :part_numbers

  PART_IDENTIFIERS = {
    '@' => 1,
    '$' => 1,
    '#' => 1,
    '*' => 1,
    '+' => 1,
    '%' => 1,
    '/' => 1,
    '=' => 1,
    '&' => 1,
    '-' => 1
  }

  def initialize(schematic:)
    @schematic = schematic
  end

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

  def sum_part_numbers
    sum = 0

    previous_line = nil
    previous_line_symbol_locations = []

    File.foreach(@schematic) do |line|
      previous_line_symbol_locations.each do |symbol_location|
        number = number_at(line, symbol_location - 1)

        if number
          (number[:start_index]..number[:end_index]).each { |i| line[i] = '.' }
          sum += number[:value]
        end

        number = number_at(line, symbol_location)

        if number
          (number[:start_index]..number[:end_index]).each { |i| line[i] = '.' }
          sum += number[:value]
        end

        number = number_at(line, symbol_location + 1)
        if number
          (number[:start_index]..number[:end_index]).each { |i| line[i] = '.' }
          sum += number[:value]
        end
      end

      previous_line_symbol_locations = []

      line.each_char.with_index do |char, i|
        next unless PART_IDENTIFIERS[char]

        previous_line_symbol_locations << i

        number = number_at(line, i - 1)

        if number
          (number[:start_index]..number[:end_index]).each { |i| line[i] = '.' }
          sum += number[:value]
        end

        number = number_at(line, i + 1)

        if number
          (number[:start_index]..number[:end_index]).each { |i| line[i] = '.' }
          sum += number[:value]
        end

        number = number_at(previous_line, i - 1)

        if number
          (number[:start_index]..number[:end_index]).each { |i| previous_line[i] = '.' }
          sum += number[:value]
        end

        number = number_at(previous_line, i)

        if number
          (number[:start_index]..number[:end_index]).each { |i| previous_line[i] = '.' }
          sum += number[:value]
        end

        number = number_at(previous_line, i + 1)

        if number
          (number[:start_index]..number[:end_index]).each { |i| previous_line[i] = '.' }
          sum += number[:value]
        end
      end

      previous_line = line
    end

    sum
  end
end

engine_fixer = EngineFixer.new(schematic: '3_input.txt')

puts engine_fixer.sum_part_numbers

