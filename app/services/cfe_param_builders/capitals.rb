module CfeParamBuilders
  class Capitals
    def self.call(form, smod_applicable: false)
      {
        bank_accounts: bank_accounts(form, smod_applicable),
        non_liquid_capital: non_liquid_capital(form, smod_applicable),
      }
    end

    def self.bank_accounts(form, smod_applicable)
      return [] unless form.savings.positive?

      [{
        value: form.savings,
        description: "Liquid Asset",
        subject_matter_of_dispute: smod_applicable && form.savings_in_dispute,
      }]
    end

    def self.non_liquid_capital(form, smod_applicable)
      [{
        value: form.investments,
        description: "Non Liquid Asset",
        subject_matter_of_dispute: smod_applicable && form.investments_in_dispute,
      },
       {
         value: form.valuables,
         description: "Non Liquid Asset",
         subject_matter_of_dispute: smod_applicable && form.valuables_in_dispute,
       }].select { _1[:value].to_i.positive? }
    end
  end
end
