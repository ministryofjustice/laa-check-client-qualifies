class PartnerCapitalSection
  PROPERTY_STEPS = %i[partner_property partner_property_entry].freeze
  TAIL_STEPS = %i[partner_assets].freeze

  class << self
    def all_steps
      (PROPERTY_STEPS + TAIL_STEPS).freeze
    end

    def steps_for(estimate)
      if estimate.asylum_support_and_upper_tribunal? || !estimate.partner
        []
      else
        property_steps = if estimate.owns_property?
                           []
                         elsif estimate.partner_owns_property?
                           PROPERTY_STEPS
                         else
                           %i[partner_property]
                         end

        ([property_steps] + TAIL_STEPS.map { |step| [step] }).freeze
      end
    end
  end
end
