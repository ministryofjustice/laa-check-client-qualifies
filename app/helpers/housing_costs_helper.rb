module HousingCostsHelper
  def housing_costs_links(level_of_help)
    {
      t("estimate_flow.housing_costs.guidance_on_housing_costs.#{level_of_help}.text") =>
        GuidanceLinkService.call(document: :"lc_guidance_#{level_of_help}", chapter: :housing_costs),
    }
  end
end
