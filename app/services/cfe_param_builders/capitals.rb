module CfeParamBuilders
  class Capitals
    def self.call(form, assets_in_dispute: [])
      {
        bank_accounts: bank_accounts(form, assets_in_dispute),
        non_liquid_capital: non_liquid_capital(form, assets_in_dispute),
      }
    end

    def self.bank_accounts(form, assets_in_dispute)
      return [] unless form.savings.positive?

      [{
        value: form.savings,
        description: "Liquid Asset",
        subject_matter_of_dispute: assets_in_dispute.include?("savings"),
      }]
    end

    def self.non_liquid_capital(form, assets_in_dispute)
      [{
        value: form.investments,
        description: "Non Liquid Asset",
        subject_matter_of_dispute: assets_in_dispute.include?("investments"),
      },
       {
         value: form.valuables,
         description: "Non Liquid Asset",
         subject_matter_of_dispute: assets_in_dispute.include?("valuables"),
       }].select { _1[:value]&.positive? }
    end
  end
end
