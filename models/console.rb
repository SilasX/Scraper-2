class Console
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
end