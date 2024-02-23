module AssetsHelper
  def assets_links(check)
    links = {
      t("question_flow.assets.guidance.#{check.level_of_help}.text") => { document: document_link(:"lc_guidance_#{check.level_of_help}", :assets), file_info: file_info(:"lc_guidance_#{check.level_of_help}") },
    }

    if check.level_of_help == "certificated"
      links[t("question_flow.assets.disregarded_capital_guidance.text")] = { document: document_link(:lc_guidance_certificated, :capital), file_info: file_info(:lc_guidance_certificated) }
      links[t("question_flow.assets.prisoner_guidance.text")] = { document: document_link(:lc_guidance_certificated, :prisoner), file_info: file_info(:lc_guidance_certificated) }
      links[t("question_flow.assets.bankrupt_guidance.text")] = { document: document_link(:lc_guidance_certificated, :bankruptcy), file_info: file_info(:lc_guidance_certificated) }
    end

    return links unless check.smod_applicable?

    links.merge({ t("generic.smod.guidance.text") => { document: document_link(:"lc_guidance_#{check.level_of_help}", :smod), file_info: file_info(:"lc_guidance_#{check.level_of_help}") } })
  end

  def partner_assets_links(check)
    links = {
      t("question_flow.assets.guidance.#{check.level_of_help}.text") => { document: document_link(:"lc_guidance_#{check.level_of_help}", :assets), file_info: file_info(:"lc_guidance_#{check.level_of_help}") },
    }

    return links if check.controlled?

    links.merge(
      t("question_flow.partner_assets.prisoner_guidance.text") => { document: document_link(:lc_guidance_certificated, :prisoner), file_info: file_info(:lc_guidance_certificated) },
      t("question_flow.partner_assets.bankrupt_guidance.text") => { document: document_link(:lc_guidance_certificated, :bankruptcy), file_info: file_info(:lc_guidance_certificated) },
    )
  end
end
