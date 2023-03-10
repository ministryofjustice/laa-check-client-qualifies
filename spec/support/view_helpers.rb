def page_text
  Nokogiri::HTML.fragment(rendered).text.gsub(/\s+/, " ")
end
