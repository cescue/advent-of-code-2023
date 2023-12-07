# frozen_string_literal: true

class CamelHand
  attr_reader :bid

  FACE_CARD_VALUES = {
    'A' => 14,
    'K' => 13,
    'Q' => 12,
    'J' => 11,
    'T' => 10
  }.freeze

  def initialize(labels, bid)
    card_counts = {}

    @cards = []

    labels.each_char do |label|
      @cards << label
      card_counts[label] ? card_counts[label] += 1 : card_counts[label] = 1
    end

    @unique_cards = @cards.uniq.length
    @most_repeats = card_counts.values.max
    @bid = bid.to_i
  end

  def five_of_a_kind?
    @unique_cards == 1
  end

  def four_of_a_kind?
    @most_repeats == 4
  end

  def three_of_a_kind?
    @unique_cards == 3 && @most_repeats == 3
  end

  def full_house?
    @unique_cards == 2 && @most_repeats == 3
  end

  def two_pair?
    @unique_cards == 3 && @most_repeats == 2
  end

  def one_pair?
    @unique_cards == 4
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

hands = File.readlines('7_input.txt').map { |line| CamelHand.new(*line.split(' '))}

hands = hands.sort_by do |hand|
  [hand.strength, hand.card_values]
end

total_winnings = 0

hands.each_with_index do |hand, i|
  total_winnings += hand.bid * (i + 1)
end

puts total_winnings