module VehicleHelper
  def vehicle_links(smod_applicable)
    links = { t("question_flow.vehicle.guidance.text") => { document: document_link(:lc_guidance_certificated, :vehicle), file_info: file_info(:lc_guidance_certificated) },
              t("generic.trapped_capital.text") => { document: document_link(:legal_aid_learning), file_info: file_info(:legal_aid_learning) } }

    return links unless smod_applicable

    links.merge({ t("generic.smod.guidance.text") => { document: document_link(:lc_guidance_certificated, :smod), file_info: file_info(:lc_guidance_certificated) } })
  end
end
