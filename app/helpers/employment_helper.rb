module EmploymentHelper
  def employment_links(check, partner: false)
    if check.controlled?
      {
        t("estimate_flow.income.guidance.text") => t("estimate_flow.income.guidance.controlled_link"),
      }
    else
      key = "estimate_flow.#{'partner_' if partner}income.police_guidance.text"
      {
        t("estimate_flow.income.guidance.text") => t("estimate_flow.income.guidance.certificated_link"),
        t(key) => t("estimate_flow.income.police_guidance.link"),
      }
    end
  end
end
