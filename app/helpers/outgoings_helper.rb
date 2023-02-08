module OutgoingsHelper
  def outgoings_links(level_of_help)
    {
      t("estimate_flow.outgoings.guidance_on_outgoings.#{level_of_help}.text") =>
        t("estimate_flow.outgoings.guidance_on_outgoings.#{level_of_help}.link"),
    }
  end
end
