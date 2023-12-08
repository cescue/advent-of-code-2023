# frozen_string_literal: true

map = {}

lines = File.readlines('8b_input.txt')

instructions = lines.first.chomp.chars.map { |char| char == 'L' ? 'left' : 'right' }

starting_positions = []

lines[2..-1].each do |line|
  captures = line.match(/^([A-Z0-9]+)\s*=\s*\(([A-Z0-9]+),\s*([A-Z0-9]+)\)/).captures

  source, left, right = captures

  starting_positions << source if source.chars.last == 'A'

  map[source] = { 'left' => left, 'right' => right }
end

steps_taken_per_route = []

starting_positions.each do |starting_position|
  current_position = starting_position
  steps_taken = 0

  while true
    break if current_position =~ /Z$/

    instructions.each do |instruction|
      current_position = map[current_position][instruction]
      steps_taken += 1
    end
  end

  steps_taken_per_route << steps_taken
end

# We're making the (big) assumption here that the first "ending" node we
# reach while traversing the paths individually is the same "ending" node
# that would be reached while the routes were traversed in parallel.
puts steps_taken_per_route.inject(:lcm)
