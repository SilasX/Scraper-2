require 'yaml'
require 'open-uri'
#require 'rss'
require 'rss/1.0'
require 'rss/2.0'

class Webscraper
  attr_reader :req_hash #:location, :min_price, :max_price
  
  def initialize(spec_file = "requirements.yml")
    @page_file_string = ""
    @req_hash = {}
    @file_name = 
    yml = YAML::load(File.open(spec_file))
    yml.each_key { |key|
      @req_hash[key] = yml[key]
      }
      
    # @location = yml['location']
    # @min_price = yml['min_price']
    # @max_price = yml['max_price']
  end
  
  def read_file(web_page_file)
    @page_file_string = open(web_page_file).read
    @file_name = web_page_file 
  end
  
  def find_links
    output = []
    site_url =       "http://sfbay.craigslist.org/search/apa?query=nice+good&srchType=A&minAsk=600&maxAsk=2000&bedrooms=1&addThree=wooof&format=rss"
    open(site_url).each_item do |rss|

      
    posts_keys = []
    posts_values = []
    doc.xpath( search_delimiter('//p/a') ).each do |node|
      
      # assert: key is not already in array (i.e. another post has same title)
      #node['string(//p/a)']] = node['/a/href']
      posts_keys << node['/a/href'] + '\n'
    end
    posts_keys
  end
  
  private
  
  def search_delimiter(string) #update later: lookup for various websites
    string
  end
  
end

wbs = Webscraper.new
#wbs.read_file("craig_test_1.html")
wbs.find_links


source = "http://sfbay.craigslist.org/search/apa?query=nice+good&srchType=A&minAsk=600&maxAsk=2000&bedrooms=1&addThree=wooof&format=rss" # url or local file
content = "" # raw content of rss feed will be loaded here
open(source) do |s| content = s.read end
rss = RSS::Parser.parse(content, false)

puts "Item values"
puts "number of items: ", rss.items.size, "\n"
puts "title of first item: ", rss.items[0].title, "\n"
puts "link of first item: ", rss.items[0].link, "\n"
#print "description of first item: ", rss.items[0].description, "\n"
puts "date of first item: ", rss.items[0].date, "\n"