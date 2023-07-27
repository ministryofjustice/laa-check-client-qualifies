module OutgoingsHelper
  def outgoings_links(level_of_help)
    {
      t("estimate_flow.outgoings.guidance_on_outgoings.#{level_of_help}.text") =>
      GuidanceLinkService.call(document: :"lc_guidance_#{level_of_help}", chapter: :outgoings),
    }
  end
end
