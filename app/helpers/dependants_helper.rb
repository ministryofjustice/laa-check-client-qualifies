module DependantsHelper
  def dependants_links(level_of_help)
    {
      t("estimate_flow.dependant_details.guidance.text") => t("estimate_flow.dependant_details.guidance.#{level_of_help}.link"),
    }
  end
end
