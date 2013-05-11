# Name
# English Name
# Acronym
# Address
# Country

require 'open-uri'
require 'net/http'
require 'nokogiri'
require 'httparty'

web4icu = 'http://www.4icu.org'

num =  14000


# print page

until num == 16000 do

    page = web4icu + '/reviews/' + num.to_s + '.htm'
    page_postfix = '/reviews/' + num.to_s + '.htm'
    output = File.open( "output6.rb", "a" )

    uri = URI.parse(page)
    result = Net::HTTP.start(uri.host, uri.port) { |http| http.get(uri.path) }
    
    if result.code == "200"
        doc = Nokogiri::HTML(open(page))
        source = open(page).read
        regex_english_name = /<a href="\d*.html">.*<\/a>/
        regex_acronym = /<acronym>\w*<\/acronym>/

        acronyms = source.match regex_acronym
        acronym =""
        unless acronyms == nil
            acronym = acronyms[0].gsub(/<acronym>/,'').gsub(/<\/acronym>/,'')
        else
            acronym = "-"
        end

        title = doc.css('title')[0].text.split('|')[0].strip

        english = source.match regex_english_name
        englishname = ""
        unless english == nil
            puts "Ouch"
            englishname = english[0].gsub(/<a href="\d*.html">/,'').gsub(/<\/a>/,'')
        else
            englishname = title
        end
        # puts englishname

        asmall = doc.css('a.asmall')
        continent = asmall[0].text
        country = asmall[1].text.strip
        state = ""
        state = asmall[2].text if country == "United States"
        # title = Nokogiri::HTML::Document.parse(HTTParty.get(page).body).title.split('|')[0].strip
        # titlecheck = title.gsub(/[^a-zA-Z&.|+\s\d]/,'')
        # if titlecheck != title
        #     title = title.gsub(/[^a-zA-Z&.|+\s\d]/,'') + "\n" + title + "\n\n"
        # end
        print num.to_s+ " | " + title + " | " + englishname + " | " + acronym + " | " + continent + " | " + country + " | " + state + "\n"
        seed = "Group.find_or_create_by({kind: 'University', name: '" + title + "', english_name: '" + englishname + "', acronym: '" + acronym + "', continent: '" + continent + "', country: '" + country + "', state: '" + state + "'})\n"
        # print seed
        
        output << seed
        
    elsif result.code == "404"
        print num.to_s + " | " + "Error: Page not found" + "\n"
    else
        print num.to_s + " | " +"Unknown Error" + "\n"
    end
    output.close
    num += 1
end
# source = Net::HTTP.get( web4icu, page)
# print source

# file_contents = open('rdomain.txt') do |f| 
#     f.read.each_line do |line|
#         newdomain = "Rdomain.find_or_create_by(name: '"  +line.strip()+  "' )\n"
#         print newdomain
#     end 
#     f.close
# end

