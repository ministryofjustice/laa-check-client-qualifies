module OutgoingsHelper
  def outgoings_links(level_of_help)
    {
      t("question_flow.outgoings.guidance_on_outgoings.#{level_of_help}.text") =>
      document_link(:"lc_guidance_#{level_of_help}", :outgoings),
    }
  end
end
