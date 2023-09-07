module HousingCostsHelper
  def housing_costs_links(level_of_help)
    {
      t("question_flow.housing_costs.guidance_on_housing_costs.#{level_of_help}.text") =>
        document_link(:"lc_guidance_#{level_of_help}", :housing_costs),
    }
  end
end
