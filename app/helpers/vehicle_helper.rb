module VehicleHelper
  def vehicle_links(smod_applicable)
    links = { t("estimate_flow.vehicle.guidance.text") => GuidanceLinkService.call(document: :lc_guidance_certificated, sub_section: :vehicle),
              t("generic.trapped_capital.text") => GuidanceLinkService.call(document: :legal_aid_learning) }

    return links unless smod_applicable

    links.merge({ t("generic.smod.guidance.text") => GuidanceLinkService.call(document: :lc_guidance_certificated, sub_section: :smod) })
  end
end
