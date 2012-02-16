require 'open-uri'

output = File.new("ruby-lang_scrape2.txt","w")

# file = open("http://www.ruby-lang.org/") {|f|
#     f.each_line {|line| output.write(line)}
#   }
#   
output.write open("http://www.ruby-lang.org/").read
  