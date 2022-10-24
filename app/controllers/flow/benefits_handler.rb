module Flow
  class BenefitsHandler
    class << self
      def model(session_data)
        BenefitsForm.new(session_data.slice(*BenefitsForm::ATTRIBUTES.map(&:to_s))).tap do |model|
          add_benefits(model, session_data)
        end
      end

      def form(params, session_data)
        BenefitsForm.new(params.require(:benefits_form)
          .permit(*BenefitsForm::ATTRIBUTES)).tap do |model|
            add_benefits(model, session_data)
          end
      end

      def add_benefits(model, session_data)
        model.benefits = session_data["benefits"]&.map do |benefits_attributes|
          BenefitModel.new benefits_attributes.slice(*BenefitModel::BENEFITS_ATTRIBUTES.map(&:to_s))
        end
      end
    end
  end
end
