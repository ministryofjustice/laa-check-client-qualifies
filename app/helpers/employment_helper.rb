module EmploymentHelper
  def employment_links(check, partner: false)
    if check.controlled?
      {
        t("question_flow.income.guidance.text") => { document: document_link(:lc_guidance_controlled, :self_employed), file_info: file_info(:lc_guidance_controlled) },
      }
    else
      key = "question_flow.#{'partner_' if partner}income.police_guidance.text"
      {
        t("question_flow.income.guidance.text") => { document: document_link(:lc_guidance_certificated, :self_employed), file_info: file_info(:lc_guidance_certificated) },
        t(key) => { document: document_link(:lc_guidance_certificated, :police), file_info: file_info(:lc_guidance_certificated) },
      }
    end
  end
end
