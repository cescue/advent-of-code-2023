# frozen_string_literal: true

input = File.readlines('6_input.txt')

time = input.first.gsub(/[^0-9]/, '').to_i
record = input.last.gsub(/[^0-9]/, '').to_i

min = (-time - Math.sqrt((time**2) - (4 * record))) / 2
max = (-time + Math.sqrt((time**2) - (4 * record))) / 2

puts (max - min).ceil