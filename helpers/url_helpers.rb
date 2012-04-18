module UrlHelper
  def is_url? string
    string.start_with?("http://")
  end
end