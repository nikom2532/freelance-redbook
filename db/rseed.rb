require 'open-uri'

file_contents = open('rdomain.txt') do |f| 
    f.read.each_line do |line|
        newdomain = "Rdomain.find_or_create_by(name: '"  +line.strip()+  "' )\n"
        print newdomain
    end 
    f.close
end
