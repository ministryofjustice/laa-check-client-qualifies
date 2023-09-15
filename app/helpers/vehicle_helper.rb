module VehicleHelper
  def vehicle_links(smod_applicable)
    links = { t("question_flow.vehicle.guidance.text") => document_link(:lc_guidance_certificated, :vehicle),
              t("generic.trapped_capital.text") => document_link(:legal_aid_learning) }

    return links unless smod_applicable

    links.merge({ t("generic.smod.guidance.text") => document_link(:lc_guidance_certificated, :smod) })
  end
end
