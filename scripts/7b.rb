# frozen_string_literal: true

class CamelHand
  attr_reader :bid, :cards

  FACE_CARD_VALUES = {
    'A' => 14,
    'K' => 13,
    'Q' => 12,
    'T' => 10,
    'J' => 1
  }.freeze

  def initialize(labels, bid)
    card_counts = {}

    @cards = []
    @total_jokers = 0

    labels.each_char do |label|
      @cards << label

      if label == 'J'
        @total_jokers += 1
        next
      end

      card_counts[label] ? card_counts[label] += 1 : card_counts[label] = 1
    end

    @unique_cards = @cards.uniq.length
    @most_repeats = card_counts.values.max
    @bid = bid.to_i
  end

  def five_of_a_kind?
    @unique_cards == 1 || @unique_cards == 2 && @total_jokers > 0
  end

  def four_of_a_kind?
    @most_repeats == 4 - @total_jokers
  end

  def three_of_a_kind?
    return @unique_cards == 3 && @most_repeats == 3 if @total_jokers.zero?

    @unique_cards == 4 && @total_jokers + @most_repeats == 3
  end

  def full_house?
    return @unique_cards == 2 && @most_repeats == 3 if @total_jokers.zero?
    
    @unique_cards == 3  && @total_jokers + @most_repeats == 3
  end

  # The presence of a joker will never create a second pair since it could also
  # be used to create a three of a kind, which scores higher.
  def two_pair?
    return @unique_cards == 3 && @most_repeats == 2 
  end

  def one_pair?
    @unique_cards == 4 || @total_jokers == 1
  end

  def strength
    return 6 if five_of_a_kind?
    return 5 if four_of_a_kind?
    return 4 if full_house?
    return 3 if three_of_a_kind?
    return 2 if two_pair?
    return 1 if one_pair?

    0
  end

  def card_values
    @cards.map { |card| [FACE_CARD_VALUES[card] || card.to_i] }
  end
end

hands = File.readlines('7_input.txt')
            .map { |line| CamelHand.new(*line.split(' '))}
            .sort_by { |hand| [hand.strength, hand.card_values] }

total_winnings = 0

hands.each_with_index do |hand, i|
  total_winnings += hand.bid * (i + 1)
end

puts total_winnings

