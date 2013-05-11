require 'open-uri'

def is_a_number?(s)
  s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
end

file_contents = open('rdomain.txt') do |f| 
    f.read.each_line do |line|
        line = line.to_s.gsub(/[()]/, "").split(' ')
        rdomain = line.shift
        line.pop if is_a_number?(line.last)
        print "\n", line.join(' ')
        rdomain = line.join(' ').to_s
    end 
    f.close
end

