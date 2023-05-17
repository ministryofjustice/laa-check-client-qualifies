module HousingCostsHelper
  def outgoings_links(level_of_help)
    {
      t("estimate_flow.housing_costs.guidance_on_housing_costs.#{level_of_help}.text") =>
        t("estimate_flow.housing_costs.guidance_on_housing_costs.#{level_of_help}.link"),
    }
  end
end
