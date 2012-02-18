require './craigscrape.rb'

describe "webscraper" do
  
  before :all do
    @webscraper = Webscraper.new("requirements.yml")
    # @webscraper.read_file("craig_test_1.html")
    @webscraper.read_file("craig_test_2.html")
  end
  
  it "successfully initializes with requirements" do
    @webscraper = Webscraper.new("requirements.yml")
    @webscraper.req_hash["location"].should be_a(String)
    @webscraper.req_hash["min_price"].should be_a(Fixnum)
    @webscraper.req_hash["max_price"].should be_a(Fixnum)
  end

  
  it "finds all links on a results page" do
    # fill in test here
  end
  
  it "extracts all email addresses from posts, ignoring those that lack one" do 
    # test
  end
  
  it "reads in form letter with options correctly filled" do
    # test
  end
  
  it "constructs and pretend-sends email properly" do
    # test
  end
end