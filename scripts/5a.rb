class AlmanacReader
  def initialize(almanac)
    @almanac = almanac

    @maps = {}

    load_almanac
  end

  def extract_ranges(almanac_entry)
    dest_range_start, source_range_start, length = almanac_entry.chomp.split(' ').map(&:to_i)

    source_range = source_range_start..source_range_start + length - 1
    dest_range = dest_range_start..(dest_range_start + length - 1)
    
    { source_range => dest_range }
  end

  def load_almanac
    current_key = nil
    
    File.foreach(@almanac) do |line|
      next if line.chomp.empty?

      if line =~ /^seeds:/
        @seeds = line.sub('seeds:', '').strip.split(' ').map(&:to_i)
        next
      end

      if line =~ /(.+)\s+map:$/
        current_key = $1
        @maps[current_key] = {}
        next
      end

      @maps[current_key].merge!(extract_ranges(line))
    end
  end

  def find_seed_location(seed)
    @maps.keys.each do |key|
      seed = extract_almanac_value(key, seed)
    end

    seed
  end

  def find_lowest_seed_location
    lowest = Float::INFINITY

    @seeds.each do |seed|
      location = find_seed_location(seed)
      lowest = location if location < lowest
    end

    lowest
  end

  def extract_almanac_value(map_name, target)
    source_range, dest_range = @maps[map_name].select { |seed| seed === target }.first

    return target unless source_range

    offset = target - source_range.first

    dest_range.first + offset
  end
end

almanac_reader = AlmanacReader.new('5_input.txt')

puts almanac_reader.find_lowest_seed_location