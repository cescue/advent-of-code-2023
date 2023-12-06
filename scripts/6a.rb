# frozen_string_literal: true

races = File.readlines('6_input.txt').map do |line|
              line.split(' ').reject { |word| word !~ /\d/ }.map(&:to_i)
            end

races = races.transpose.to_h

total_ways_to_beat_records = races.map do |time, record_distance|
  ways_to_win = 0

  time.times do |ms|
    speed = ms
    travel_time = time - ms
    distance = speed * travel_time

    ways_to_win += 1 if distance > record_distance
  end
  
  ways_to_win
end

puts total_ways_to_beat_records.inject(:*)