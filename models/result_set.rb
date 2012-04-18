require '../helpers/url_helpers.rb'
require 'nokogiri'
require 'rss'

class ResultSet
  include UrlHelper
  attr_accessor :results
  def initialize results = {}
    #@results is a hash mapping a url to ALL its info
    @results = results
  end

  def accumulate_from search_url
    res_output = Result.new
    # fill the @results array with hashes of valid results
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
      # puts rss_structure
      # puts rss_structure.class
      rss_structure.items.each { |item| 
         result_hash[item.title] = item.link }
    end
    @postings_hash = result_hash # keys = posting titles, values = posting URLs
  end

end
