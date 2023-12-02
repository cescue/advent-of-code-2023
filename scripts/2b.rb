# frozen_string_literal: true

class CubeGame
  def initialize(red_cubes: 0, green_cubes: 0, blue_cubes: 0)
    @red_cubes = red_cubes
    @green_cubes = green_cubes
    @blue_cubes = blue_cubes
  end

  def minimum_cubes_for_game(record)
    minimum_cubes = { red: 0, green: 0, blue: 0 }

    record.split(':').last.split(';').each do |hand|
      hand = hand.scan(/(\d+)\s(red|green|blue)/)
                 .map { |capture| [capture[1].to_sym, capture[0].to_i] }
                 .to_h

      hand.keys.each do |color|
        minimum_cubes[color] = hand[color] if minimum_cubes[color] < hand[color]
      end
    end

    minimum_cubes
  end
end

game = CubeGame.new

sum_of_powers = 0

File.foreach('2_input.txt') do |line|
  sum_of_powers += game.minimum_cubes_for_game(line).values.inject(:*)
end

puts sum_of_powers
