module EmploymentHelper
  def employment_links(check, partner: false)
    return {} unless !check.controlled? && FeatureFlags.enabled?(:special_applicant_groups)

    key = "estimate_flow.#{'partner_' if partner}employment.police_guidance.text"
    {
      t(key) => t("estimate_flow.employment.police_guidance.link"),
    }
  end
end
