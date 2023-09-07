module DependantsHelper
  def dependants_links(level_of_help)
    {
      t("question_flow.dependant_details.guidance.text") => document_link(:"lc_guidance_#{level_of_help}", :dependants_allowance),
    }
  end

  def dependant_income_links(level_of_help)
    {
      t("question_flow.dependant_income.guidance") => document_link(:"lc_guidance_#{level_of_help}", :dependants_allowance),
    }
  end
end
