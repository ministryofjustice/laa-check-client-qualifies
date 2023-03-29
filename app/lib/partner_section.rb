class PartnerSection
  class << self
    def all_steps
      %i[partner_details partner_dependant_details]
    end

    def steps_for(session_data)
      if !NavigationHelper.partner?(session_data)
        []
      elsif NavigationHelper.passported?(session_data)
        %i[partner_details].map { [_1] }
      else
        %i[partner_details partner_dependant_details].map { [_1] }
      end
    end
  end
end
