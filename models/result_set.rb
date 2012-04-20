require '../helpers/url_helpers.rb'
require 'rss'
require 'hpricot'
require 'open-uri'
require 'dm-serializer'

class ResultSet
  include UrlHelper
  attr_accessor :results
  def initialize results = {}
    #@results is a hash mapping a url to ALL its info
    @results = results
  end

  def accumulate_from search_url
    res_output = Result.new
    # function should be updated to take the next result here instead 
  end

  def extract_rss_link_info(rss_url)
    result_hash = {} #doing as hash
    open(rss_url) do |content|
      # puts content.read
      begin
      rss_structure = RSS::Parser.parse(content, true, true)
      rescue
        puts "No results found.  Try a different search and make sure you get the URL right."
        return
      end
      attr_store = [:title,:description] 
      rss_structure.items.each do |item| 
        post_link = item.link
        if @results[post_link] == nil
          @results[post_link] = Hash[attr_store.zip attr_store.map{|x| item.send(x)} ]
          @results[post_link][:contact] = {:main_email => extract_email(post_link) }
        end
      end
    end
    File.open('cached_listings.yml','w') {|f| f.write(@results.to_yaml) }
#    result_hash.each do |k,v|
#      puts "#{k} => {:title => #{v[:title]}, :email => #{v[:email]}"
#    end
  end

  def extract_email link
    doc = open(link) {|f| Hpricot(f) }
    doc.search("//a[@href*='mailto']").inner_html
  end

end
