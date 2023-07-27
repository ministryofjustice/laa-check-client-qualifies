module EmploymentHelper
  def employment_links(check, partner: false)
    if check.controlled?
      {
        t("estimate_flow.income.guidance.text") => GuidanceLinkService.call(document: :lc_guidance_controlled, chapter: :self_employed),
      }
    else
      key = "estimate_flow.#{'partner_' if partner}income.police_guidance.text"
      {
        t("estimate_flow.income.guidance.text") => GuidanceLinkService.call(document: :lc_guidance_certificated, chapter: :self_employed),
        t(key) => GuidanceLinkService.call(document: :lc_guidance_certificated, chapter: :police),
      }
    end
  end
end
