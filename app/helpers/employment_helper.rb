module EmploymentHelper
  def employment_links(check, partner: false)
    if check.controlled?
      {
        t("question_flow.income.guidance.controlled_text") => document_link(:lc_guidance_controlled, :self_employed),
      }
    else
      key = "question_flow.#{'partner_' if partner}income.police_guidance.text"
      {
        t("question_flow.income.guidance.certificated_text") => document_link(:lc_guidance_certificated, :self_employed),
        t(key) => document_link(:lc_guidance_certificated, :police),
      }
    end
  end
end
