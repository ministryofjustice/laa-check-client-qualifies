module Flow
  module Benefits
    class DetailsHandler
      class << self
        def model(session_data, _index)
          BenefitDetailsForm.new session_data.slice(*BenefitDetailsForm::ATTRIBUTES.map(&:to_s))
        end

        def form(params, _session_data, _index)
          BenefitDetailsForm.new(params.require(:benefit_details_form)
                                       .permit(*BenefitDetailsForm::ATTRIBUTES))
        end

        def save_data(_cfe_connection, _estimate_id, form, session_data)
          benefits = session_data.fetch("benefits", [])
          session_data[:benefits] = benefits << form.attributes
          # clear form data for next time
          session_data.except!(*BenefitDetailsForm::ATTRIBUTES.map(&:to_s))
        end
      end
    end
  end
end
