require 'rspec'
require '../models/result_set.rb'

describe ResultSet do
  before :each do
    @rs1 = ResultSet.new
    @post_email = "CL_sample_result_w_email.html"
    @post_no_email = "CL_sample_result_wout_email.html"
  end
  describe "email scraping" do
    it "should find an email if it exists in the posting" do
      @rs1.extract_email(@post_email).should == 
      "zr2v3-2965690199@job.craigslist.org"
    end
    
    it "should find no email if none is given at the top of the posting" do
      @rs1.extract_email(@post_no_email).should == ""
    end

  end
end
