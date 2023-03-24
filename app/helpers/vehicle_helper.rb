module VehicleHelper
  def vehicle_links(smod_applicable)
    links = { t("estimate_flow.vehicle.guidance.text") => t("estimate_flow.vehicle.guidance.link"),
              t("generic.trapped_capital.text") => t("generic.trapped_capital.certificated.link") }

    return links unless smod_applicable

    links.merge({ t("generic.smod.guidance.text") => t("generic.smod.guidance.certificated.link") })
  end
end
