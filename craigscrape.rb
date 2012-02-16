require 'yaml'

class Webscraper
  attr_reader :req_hash #:location, :min_price, :max_price
  
  
  def initialize(spec_file = "requirements.yml")
    @req_hash = {}
    yml = YAML::load(File.open(spec_file))
    yml.each_key { |key|
      @req_hash[key] = yml[key]
      }
    # @location = yml['location']
    # @min_price = yml['min_price']
    # @max_price = yml['max_price']
  end
end

puts Webscraper.new.req_hash.inspect