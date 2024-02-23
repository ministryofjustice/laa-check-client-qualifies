module DependantsHelper
  def dependants_links(level_of_help)
    {
      t("question_flow.dependant_details.guidance.text") => { document: document_link(:"lc_guidance_#{level_of_help}", :dependants_allowance), file_info: file_info(:"lc_guidance_#{level_of_help}") },
    }
  end

  def dependant_income_links(level_of_help)
    {
      t("question_flow.dependant_income.guidance.text") => { document: document_link(:"lc_guidance_#{level_of_help}", :dependants_allowance), file_info: file_info(:"lc_guidance_#{level_of_help}") },
    }
  end
end
