# frozen_string_literal: true

calibration_doc = File.read('1_input.txt')

def extract_calibration_value(line)
  first_digit = nil
  last_digit = nil

  line.length.times do |i|
    first_digit = line[i] if first_digit.nil? && line[i] =~ /\d/
    last_digit = line[line.length - 1 - i] if last_digit.nil? && line[line.length - 1 - i] =~ /\d/

    return "#{first_digit}#{last_digit}".to_i if first_digit && last_digit
  end
end

sum_of_calibration_values = 0

calibration_doc.each_line { |line| sum_of_calibration_values += extract_calibration_value(line) }

puts sum_of_calibration_values