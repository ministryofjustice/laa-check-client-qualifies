module Flow
  module Benefits
    class YesnoHandler
      class << self
        def model(session_data, _index)
          BenefitYesnoForm.new session_data.slice(*BenefitYesnoForm::ATTRIBUTES.map(&:to_s))
        end

        def form(params, _session_data, _index)
          BenefitYesnoForm.new(params.fetch(:benefit_yesno_form, {})
                                     .permit(*BenefitYesnoForm::ATTRIBUTES))
        end

        def save_data(cfe_connection, estimate_id, form, session_data); end
      end
    end
  end
end
