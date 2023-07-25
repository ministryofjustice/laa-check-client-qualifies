module GuidanceLinkHelper
  def guidance_link(text, check)
    prefix = if FeatureFlags.enabled?(feature_flag, without_session_data: true)
               "mtr_phase_1"
             else
               "pre_mtr_phase_1"
             end

    link.merge = {
      t("#{prefix}.#{text}.text") => t("#{prefix}.#{text}.#{check.level_of_help}.link"),
    }
  end
end


- guidance_link("unacceptable_client_explanation_under_18_html", @check)