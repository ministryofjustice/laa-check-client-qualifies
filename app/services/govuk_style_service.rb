class GovukStyleService
  def self.call(rich_text_field)
    fragment = Nokogiri::HTML5.fragment(rich_text_field)
    fragment.search("p").each { _1["class"] = "govuk-body" }
    fragment.search("h3").each { _1["class"] = "govuk-heading-s" }
    fragment.search("ul").each { _1["class"] = "govuk-list govuk-list--bullet" }
    fragment.search("ol").each { _1["class"] = "govuk-list govuk-list--number" }
    fragment.to_s
  end
end
