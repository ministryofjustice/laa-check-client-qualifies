module CheckAnswers
  class SectionListerService
    FieldData = Struct.new(:label, :type, :value, :alt_value, :relevancy_value, :disputed?, :index, :screen, keyword_init: true)

    class << self
      def call(session_data)
        check = Check.new(session_data)

        non_finance_sections = [
          Sections::ClientDetails.new(check),
          Sections::CaseDetails.new(check),
        ]
        if check.skip_client_questions?
          non_finance_sections
        else
          assets = [
            Sections::HousingAndProperty.new(check),
            Sections::Assets.new(check),
          ]

          if check.skip_income_questions?
            if check.partner?
              # Partner Income section included 'partner age'
              non_finance_sections + [Sections::PartnerIncome.new(check)] + assets
            else
              non_finance_sections + assets
            end
          else
            finance_sections = [
              Sections::Dependants.new(check),
              Sections::ClientIncome.new(check),
              Sections::PartnerIncome.new(check),
              Sections::Outgoings.new(check),
            ]
            non_finance_sections + finance_sections + assets
          end
        end
      end
    end
  end
end
