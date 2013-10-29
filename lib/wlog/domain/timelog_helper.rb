module Wlog
# Helper class that reads in a string in the form of eg: 4h20m and should be
# able to extract time in seconds.
# @author Simon Symeonidis
class TimelogHelper
  # Parse a timelog string
  def self.parse(str)
    loggings = str.scan(/\d+[A-Za-z]/)
    self.calculate_time(loggings)
  end

private_class_method
  # Calculate time interface (get an array of time entries, and calculate)
  def self.calculate_time(time_arr)
    time_arr.inject(0){|sum,el| sum += self.calculate_item(el)}
  end

  # Calculate one time entry
  def self.calculate_item(time_item)
    magnitude = Times[time_item[-1]]
    time_item.to_i * magnitude
  end

  Times = {
    'h' => 60 * 60,
    's' => 1,
    'm' => 60,
    'd' => 8 * 60 * 60, # We assume logging a day = 8 hours
    'w' => 8 * 60 * 60 * 7
  }
end
end
