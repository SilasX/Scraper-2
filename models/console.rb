require "../helpers/url_helpers.rb"
class Console

  include UrlHelper

  def run
    invalid_input_response = open("../invalid_input_response.txt").read
    instructions = open("../instructions.txt").read
    command = "wrong"
    puts instructions
    while command != 'q'
      puts "Paste the search url here and hit enter >"
      command = gets.chomp
      case 
      when is_url?(command)
        puts "great, I'm proud of you, you input a proper url ... you want a medal now, I guess?"
        r1 = Result.from_search(command)
# search_and_email_cycle(command)
      when command == 'q'
        puts "Leaving Craiglist Scraper Program ..."
      else
        puts invalid_input_response
      end
    end
    # links = extract_rss_link_info
  end
end

c1 = Console.new
c1.run
