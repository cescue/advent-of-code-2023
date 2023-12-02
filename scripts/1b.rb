# frozen_string_literal_ true

class TrebuchetCalibrator
  DIGITS = {
    'one' => 1,
    'two' => 2,
    'three' => 3,
    'four' => 4,
    'five' => 5,
    'six' => 6,
    'seven' => 7,
    'eight' => 8,
    'nine' => 9
  }.freeze

  def initialize(calibration_document:)
    assemble_lookup_tables!

    @calibration_document = calibration_document
  end

  def sum_calibration_values
    sum = 0

    File.foreach(@calibration_document) do |line|
      sum += extract_calibration_value(line)
    end

    sum
  end

  def update_digit(digit, next_character, lookup_table)
    return digit if digit.is_a?(Integer)

    return next_character.to_i if next_character =~ /\d/

    digit = "#{digit}#{next_character}"

    return lookup_table[digit] if lookup_table[digit].is_a?(Integer)

    unless lookup_table[digit]
      until digit.empty?
        digit = digit[1..-1]

        return digit if lookup_table[digit]
      end

      return lookup_table[next_character] ? next_character : ''
    end

    digit
  end

  def extract_calibration_value(line)
    first_digit = ''
    last_digit = ''
  
    line.length.times do |i|
      first_digit = update_digit(first_digit, line[i], @lookup_table)
      last_digit = update_digit(last_digit, line[line.length - 1 - i], @inverse_lookup_table)

      next unless first_digit.is_a?(Integer) && last_digit.is_a?(Integer)

      return "#{first_digit}#{last_digit}".to_i
    end
  end

  # Builds two pseudo-memoized "lookup" hashes using the DIGITS hash. In both lookup hashes, the original
  # keys correspond to the original values.
  #
  # In the first hash, consecutive substrings are keyed to the value `true``:
  # { 'o' => true, 'on' => true, 'one' => 1, ..., 'nine' => 9 }
  #
  # In the second hash, consecutive substrings of the _reversed_ key are keyed to `true`:
  # { 'e' => true, 'en' => true, 'eno' => 1 }
  #
  # This is meant to make substring lookups less expensive when determining if we're looking at a valid
  # digit string. It would have taken less time to build these by hand, but this was more fun!

  def assemble_lookup_tables!
    @lookup_table = {}
    @inverse_lookup_table = {}

    DIGITS.keys.each do |key|
      (key.length - 1).times { |i| @lookup_table[key[0..i]] = true }
      (key.length - 1).times { |i| @inverse_lookup_table[key.reverse[0..i]] = true }
      @lookup_table[key] = DIGITS[key]
      @inverse_lookup_table[key.reverse] = DIGITS[key]
    end
  end
end

calibrator = TrebuchetCalibrator.new(calibration_document: '1_input.txt')

puts calibrator.sum_calibration_values


