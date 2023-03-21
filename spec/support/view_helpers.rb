def page_text
  Nokogiri::HTML.fragment(rendered).text.gsub(/\s+/, " ")
end

def page_text_within(css_selector)
  Nokogiri::HTML.fragment(rendered).at_css(css_selector).text.gsub(/\s+/, " ")
end
