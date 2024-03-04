module AssetsHelper
  def assets_links(check)
    links = {
      t("question_flow.assets.guidance.#{check.level_of_help}.text") => document_link(:"lc_guidance_#{check.level_of_help}", :assets),
    }

    if check.level_of_help == "certificated"
      links[t("question_flow.assets.disregarded_capital_guidance.text")] = document_link(:lc_guidance_certificated, :capital)
      links[t("question_flow.assets.prisoner_guidance.text")] = document_link(:lc_guidance_certificated, :prisoner)
      links[t("question_flow.assets.bankrupt_guidance.text")] = document_link(:lc_guidance_certificated, :bankruptcy)
    end

    return links unless check.smod_applicable?

    links.merge({ t("generic.smod.guidance.#{check.level_of_help}_text") => document_link(:"lc_guidance_#{check.level_of_help}", :smod) })
  end

  def partner_assets_links(check)
    links = {
      t("question_flow.assets.guidance.#{check.level_of_help}.text") => document_link(:"lc_guidance_#{check.level_of_help}", :assets),
    }

    return links if check.controlled?

    links.merge(
      t("question_flow.partner_assets.prisoner_guidance.text") => document_link(:lc_guidance_certificated, :prisoner),
      t("question_flow.partner_assets.bankrupt_guidance.text") => document_link(:lc_guidance_certificated, :bankruptcy),
    )
  end
end
