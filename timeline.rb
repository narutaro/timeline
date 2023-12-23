#!/usr/bin/env ruby

require 'time'

class Time
  def with_timezone(timezone = 'UTC')
    old = ENV['TZ']
    utc = self.dup.utc
    ENV['TZ'] = timezone
    output = utc.localtime
    ENV['TZ'] = old
    output
  end
end

column_width = 13

airport_info = {
  'MEL' => ['Australia/Melbourne', '🇦🇺'],
  'HND' => ['Asia/Tokyo', '🇯🇵'],
  'ICN' => ['Asia/Seoul', '🇰🇷'],
  'SIN' => ['Asia/Singapore', '🇸🇬'],
  'DEL' => ['Asia/Kolkata', '🇮🇳'],
  'LHR' => ['Europe/London', '🇬🇧'],
  'JFK' => ['America/New_York', '🇺🇸'],
  'SFO' => ['America/Los_Angeles', '🇺🇸'],
}

# Format emoji
def format(flag, code, column_width)
  # Format with the temporary text "@" for layout
  column_span = ("@" + "  #{code}").ljust(column_width) 
  # Replace the "@" with flag emoji
  column_span.gsub('@', "#{flag}") 
end

def gray_text(text)
  "\033[#{90}m#{text}\033[0m"
end

# Header
flag_line = ""
timezone_line = ""
bar = ""

airport_info.map { |code, (timezone, flag)| 
  flag_line += format(flag, code, column_width)
  t = Time.now.with_timezone(timezone)
  timezone_line += (t.zone + "/" + t.strftime('%:z')).ljust(column_width)
  bar += "-" * column_width 
}

puts flag_line
puts timezone_line
puts bar

# Time
24.times do |i|
  airport_info.each do |code, (timezone, flag)|

    local_time = Time.now + 60 * 60 * i
    rounded_local_time = Time.at((local_time.to_i / 1800.0).ceil * 1800)
    rounded_remote_time = rounded_local_time.with_timezone(timezone)

    time_text = rounded_remote_time.strftime('%m/%d %H:%M').ljust(column_width)

    # Gray out the non-working time
    if rounded_remote_time.hour > 8 && rounded_remote_time.hour < 18
      time_text
    else
      time_text = gray_text(time_text)
    end
    print time_text

  end
  puts
end
