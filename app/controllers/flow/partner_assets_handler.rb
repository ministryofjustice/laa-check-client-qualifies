module Flow
  class PartnerAssetsHandler < PartnerHandler
    # The original form class is 'BaseAssetsForm', and we want to ensure 'Base' is omitted
    def partner_form_class_name
      @partner_form_class_name ||= "PartnerAssetsForm"
    end
  end
end
