module Wlog
  # Helper class that reads in a string in the form of eg: 4h20m and should be
  # able to extract time in seconds.
  # @author Simon Symeonidis
  class TimelogHelper
    # Parse a timelog string
    def self.parse(str)
      loggings = str.scan(/\d+[A-Za-z]/)
      calculate_time(loggings)
    end

    # @param time is time in seconds
    # @return in nice format (2d 1h 20m)
    def self.time_to_s(time)
      str = ''
      TimesArr.each do |interval|
        rem = time % interval
        occ = (time - rem) / interval
        str.concat("#{occ}#{TimesRev[interval]} ") if occ > 0
        time = rem
      end
      str end

    private_class_method
    # Calculate time interface (get an array of time entries, and calculate)
    def self.calculate_time(time_arr)
      time_arr.inject(0) { |sum, el| sum += calculate_item(el) }
    end

    # Calculate one time entry
    def self.calculate_item(time_item)
      magnitude = Times[time_item[-1]]
      time_item.to_i * magnitude
    end

    def self.count_occurences(time, step); end

    Times = {
      'h' => 60 * 60,
      's' => 1,
      'm' => 60,
      'd' => 8 * 60 * 60, # We assume logging a day = 8 hours
      'w' => 8 * 60 * 60 * 7
    }.freeze

    # Reverse format for times
    TimesRev = Hash[Times.to_a.collect { |arr| arr.reverse }]

    # For a format to output a given int to time (1221 => 20m 21s)
    TimesArr = Times.to_a.sort { |x1, x2| x2[1] <=> x1[1] }.collect { |e| e[1] }
  end
end
