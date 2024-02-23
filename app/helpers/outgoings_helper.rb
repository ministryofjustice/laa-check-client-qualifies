module OutgoingsHelper
  def outgoings_links(level_of_help)
    {
      t("question_flow.outgoings.guidance_on_outgoings.#{level_of_help}.text") =>
      { document: document_link(:"lc_guidance_#{level_of_help}", :outgoings), file_info: file_info(:"lc_guidance_#{level_of_help}") },
    }
  end
end
