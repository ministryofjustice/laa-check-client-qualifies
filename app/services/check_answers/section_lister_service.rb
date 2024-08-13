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
        if check.non_means_tested?
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
            pre = [
              Sections::Dependants.new(check),
              Sections::ClientIncome.new(check),
            ]
            post = [Sections::Outgoings.new(check)]
            finance_sections = if check.partner?
                                 pre + [Sections::PartnerIncome.new(check)] + post
                               else
                                 pre + post
                               end
            non_finance_sections + finance_sections + assets
          end
        end
      end
    end
  end
end
