# frozen_string_literal: true

class CubeGame
  def initialize(red_cubes: 0, green_cubes: 0, blue_cubes: 0)
    @red_cubes = red_cubes
    @green_cubes = green_cubes
    @blue_cubes = blue_cubes
  end

  def possible_hand?(red: 0, green: 0, blue: 0)
    red <= @red_cubes && green <= @green_cubes && blue <= @blue_cubes
  end

  def possible_game?(record)
    record.split(':').last.split(';').each do |hand|
      hand = hand.scan(/(\d+)\s(red|green|blue)/)
                 .map { |capture| [capture[1].to_sym, capture[0].to_i] }
                 .to_h

      return false unless possible_hand?(**hand)
    end

    true
  end
end

game = CubeGame.new(red_cubes: 12, green_cubes: 13, blue_cubes: 14)

sum_of_game_ids = 0

File.foreach('2_input.txt') do |line|
  id = line.match(/^Game (\d+):/).captures.first.to_i

  next unless game.possible_game?(line)

  sum_of_game_ids += id
end

puts sum_of_game_ids