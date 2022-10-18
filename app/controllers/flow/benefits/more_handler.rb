module Flow
  module Benefits
    class MoreHandler
      class << self
        def model(session_data, _index)
          BenefitMoreForm.new session_data.slice(*BenefitMoreForm::ATTRIBUTES.map(&:to_s))
        end

        def form(params, session_data, _index)
          BenefitMoreForm.new(params.fetch(:benefit_more_form, {})
                                       .permit(*BenefitMoreForm::FORM_ATTRIBUTES)
                                    .merge(session_data.slice(*BenefitMoreForm::BENEFITS_ATTRIBUTES.map(&:to_s))))
        end

        def save_data(cfe_connection, estimate_id, form, session_data)
          unless form.more_benefits
            benefits = session_data.fetch("benefits", []).map do |b|
              BenefitDetailsForm.new(b).attributes.symbolize_keys.except(:index)
            end
            cfe_connection.create_benefits(estimate_id, benefits)
          end
        end
      end
    end
  end
end
