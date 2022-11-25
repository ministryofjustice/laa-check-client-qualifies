class PartnerSection
  class << self
    def all_steps
      %i[partner_details partner_dependant_details]
    end

    def steps_for(estimate)
      if !estimate.partner
        []
      else
        %i[partner_details partner_dependant_details].map { [_1] }
      end
    end
  end
end
