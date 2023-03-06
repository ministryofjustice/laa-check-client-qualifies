class PartnerSection
  class << self
    def all_steps
      %i[partner_details]
    end

    def steps_for(estimate)
      if !estimate.partner || estimate.asylum_support_and_upper_tribunal?
        []
      else
        %i[partner_details].map { [_1] }
      end
    end
  end
end
