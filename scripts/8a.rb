# frozen_string_literal: true

map = {}

lines = File.readlines('8_input.txt')

instructions = lines.first.chomp.chars.map { |char| char == 'L' ? 'left' : 'right' }

lines[2..-1].each do |line|
  captures = line.match(/^([A-Z]+)\s*=\s*\(([A-Z]+),\s*([A-Z]+)\)/).captures

  source, left, right = captures

  map[source] = { 'left' => left, 'right' => right }

end

current_position = 'AAA'
target_position = 'ZZZ'
steps_taken = 0

while true
  break if current_position == target_position

  instructions.each do |instruction|
    current_position = map[current_position][instruction]
    steps_taken += 1
  end
end

puts steps_taken