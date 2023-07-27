module DependantsHelper
  def dependants_links(level_of_help)
    {
      t("estimate_flow.dependant_details.guidance.text") => GuidanceLinkService.call(document: :"lc_guidance_#{level_of_help}", chapter: :dependants_allowance),
    }
  end
end
