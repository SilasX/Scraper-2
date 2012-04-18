module UrlHelper
  def is_url? string
    string.start_with?("http://")
  end
  def format_search_url url_string
    url_string.end_with?("&format=rss") ? url_string : url_string + "&format=rss"
  end
end
