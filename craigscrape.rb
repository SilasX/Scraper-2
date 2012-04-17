require 'yaml'
require 'open-uri'
require 'rss'
require 'rubygems'
#require 'pony'

class Webscraper
  attr_reader :sender_data, :email_hash
  
  def initialize(sender_data_file = "sender_data.yml")
    @postings_hash = {} # keys = posting titles, values = posting URLs
    @email_hash = {} # keys = email addresses, #values = posting titles
    @sender_data = {}
    yml = YAML::load(File.open(sender_data_file))
    yml.each do |key, value|
      @sender_data[key.intern] = value
    end
    # @sender_data = {   
    #                   :first_name     => "John", 
    #                   :last_name      => "Jagenmeier", 
    #                   :email_address  => "john.jagenmeier@gmail.com",
    #                   :email_password => "silas_has_shortcomings", 
    #                }
    # @req_hash = {}
    # yml = YAML::load(File.open(spec_file))
    # yml.each_key { |key|
    #   @postings_hash[key] = yml[key]
    #   }
  end
  
  def run
    invalid_input_response = open("invalid_input_response.txt").read
    instructions = open("instructions.txt").read
    command = "wrong"
    puts instructions
    while command != 'q'
      puts "Paste the search url here and hit enter >"
      command = gets.chomp
      case 
      when is_url?(command)
        search_and_email_cycle(command)
      when command == 'q'
        puts "Leaving Craiglist Scraper Program ..."
      else
        puts invalid_input_response
      end
    end
    # links = extract_rss_link_info
  end
  
  def search_and_email_cycle(search_url)
    search_url = format_search_url(search_url)
    extract_rss_link_info(search_url)
    collect_valid_emails #get results with email addresses, associate them with related data
    email_posters
    #report_results
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
  
  def collect_valid_emails
    @postings_hash.each do |key, value|
      open(value) do |f| 
        match_obj = f.read.match("mailto:")
        if match_obj != nil
          email_string = match_obj.post_match
          email_string = email_string.match(/[?]/).pre_match
          @email_hash[email_string]= { :title => key, # hash of hashes
                                       :url => value,
                                       :text => extract_post_body(value)
                                     }
          #puts @email_hash[email_string]
        end
      end
    end
  end
  
  def email_posters
    @email_hash.each do |email, post_title|
      #send_email(email,"Re: #{post_title}", construct_form_letter_string(post_title) )
      ## test output: creates files in subdirectory
      form_letter_template = open("Form_letter.txt").read
      FileUtils.mkpath 'emails/sub'
      File.open("emails/sub/" + email.gsub("@","_") + ".txt" , "w") do |f|
        f.write( construct_form_letter_string(form_letter_template, email) )
      end
      ## (nearer) production output
      #send_email("john.jagenmeier@gmail.com","Re: #{email} #{post_title}", "Some Text" )
    end
    
  end
  
  def send_email(to, subject, body)
    Pony.mail(  :to => to, 
                :subject => subject, 
                :body => body,
                :via => :smtp, 
                :via_options => {
                    :address              => 'smtp.gmail.com',
                    :port                 => '587',
                    :enable_starttls_auto => true,
                    :user_name            => @sender_data[:email_address].delete("@gmail.com"),
                    :password             => @sender_data[:email_address],
                    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
                    :domain               => "HELO" # the HELO domain provided by the client to the server
                }
                #:sender => sender_name
              )
    #emailing persona:
    #Name: John Jagenmeier
    #email: john.jagenmeier@gmail.com
    #password: silas_has_shortcomings
  end
  
  def random_text_excerpt(string, excerpt_word_length)
    #assert(excerpt_word_length > 0 and excerpt_word_length < string.split.length)
    word_array = string.split
    start_index = rand(word_array.length - excerpt_word_length)
    output_string = word_array[start_index .. start_index + excerpt_word_length - 1]
    output_string.join(" ")
  end
  
  #private
  
  def extract_post_body(url)
    post_string = ""
    open(url) do |f|
      match_obj = f.read.match("<div id=\"userbody\">")
      post_string = match_obj.post_match
      post_string = post_string.match("<!-- START CLTAGS -->").pre_match
    end
    post_string.gsub(%r{</?[^>]+?>}, '')
  end
      

  
  def construct_form_letter_string(template_string, sender_email)
    output = template_string
    simple_substitutions = {
                    "#Our_Email" => @sender_data[:email_address],
                    "#Sender_Email" => sender_email,
                    "#Date" => Time.now.utc.to_s,
                    "#Our_First_Name" => @sender_data[:first_name],
                    "#Our_Last_Name" => @sender_data[:last_name],
                    "#Link" => @email_hash[sender_email][:url]
                          }
    simple_substitutions.each do |key, value|
      output = output.gsub(key, value)
    end
    output = output.gsub( "#random_string_from_post", random_text_excerpt(@email_hash[sender_email][:text], 5) )
    output
  end
  
  def search_delimiter(string) #update later: lookup for various websites
    string
  end
  
  # def read_file(web_page_file)
  #   @page_file_string = open(web_page_file).read
  #   @file_name = web_page_file 
  # end
  
  def is_url? string
    string.start_with?("http://")
  end
  
  def format_search_url url_string
    url_string.end_with?("&format=rss") ? url_string : url_string + "&format=rss"
  end
  
end

form_letter_template = open("Form_letter.txt").read
wbs = Webscraper.new
wbs.run
#puts wbs.construct_form_letter_string(form_letter_template,"sbarta@gmail.com")