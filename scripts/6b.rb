# frozen_string_literal: true

input = File.readlines('6_input.txt')

time = input.first.gsub(/[^0-9]/, '').to_i
record = input.last.gsub(/[^0-9]/, '').to_i

ways_to_win = []

midpoint = time / 2
ms_offset = 0

while true
  next_ms = midpoint + ms_offset
  prev_ms = midpoint - ms_offset

  next_speed = next_ms
  next_travel_time = time - next_ms
  next_distance = next_speed * next_travel_time

  ways_to_win << next_ms if next_distance > record

  prev_speed = prev_ms
  prev_travel_time = time - prev_ms
  prev_distance = prev_speed * prev_travel_time

  ways_to_win << prev_ms if prev_distance > record

  break if prev_distance < record && next_distance < record

  ms_offset += 1
end

puts ways_to_win.uniq.length
