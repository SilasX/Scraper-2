require './craigscrape.rb'

describe "webscraper" do
  
  before :all do
    @webscraper = Webscraper.new
  end
  
  it "successfully initializes with requirements" do
    @webscraper.req_hash["location"].should be_a(String)
    @webscraper.req_hash["min_price"].should be_a(Fixnum)
    @webscraper.req_hash["max_price"].should be_a(Fixnum)
  end
  # 
  # it "returns craigslist results" do
  # end
  # 
  # it "successfully creates email to poster" do
  # end
end