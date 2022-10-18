module Flow
  module Benefits
    class EditHandler
      class << self
        def model(session_data, index)
          benefits = session_data.fetch("benefits", [])[index]
          BenefitDetailsForm.new benefits.merge(index:)
        end

        def form(params, _session_data, _index)
          BenefitDetailsForm.new(params.require(:benefit_details_form)
                                       .permit(*BenefitDetailsForm::ATTRIBUTES))
        end

        def save_data(_cfe_connection, _estimate_id, form, session_data)
          benefits = session_data.fetch("benefits", [])
          benefits[form.index] = form.attributes.except(:index)
          session_data[:benefits] = benefits
          # clear form data for next time
          session_data.except!(*BenefitDetailsForm::ATTRIBUTES.map(&:to_s))
        end
      end
    end
  end
end
