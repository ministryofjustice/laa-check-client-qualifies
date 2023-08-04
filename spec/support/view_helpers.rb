def page_text
  Nokogiri::HTML.fragment(rendered).text.gsub(/\s+/, " ")
end

def page_text_within(css_selector)
  Nokogiri::HTML.fragment(rendered).at_css(css_selector).text.gsub(/\s+/, " ")
end

def expect_in_text(text, strings)
  # First check each individual string, so we get an expressive error if one is missing
  strings.each { expect(text).to include(_1) }

  # Now check the order of the strings
  indexes = strings.map { text.index(_1) }
  expect(indexes.sort).to eq(indexes)
end
