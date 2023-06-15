module EmploymentHelper
  def employment_links(check, partner: false)
    return {} if check.controlled? || !FeatureFlags.enabled?(:special_applicant_groups)

    key = "estimate_flow.#{'partner_' if partner}income.police_guidance.text"
    {
      t(key) => t("estimate_flow.income.police_guidance.link"),
    }
  end
end
