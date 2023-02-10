class PartnerSection
  class << self
    def all_steps
      %i[partner_details partner_dependant_details]
    end

    def steps_for(estimate)
      if !estimate.partner || estimate.asylum_support
        []
      elsif estimate.passporting
        %i[partner_details].map { [_1] }
      else
        %i[partner_details partner_dependant_details].map { [_1] }
      end
    end
  end
end
