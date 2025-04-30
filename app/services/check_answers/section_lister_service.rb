module CheckAnswers
  class SectionListerService
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
              # Simplecov is showing that check.under_eighteen_assets? is not being covered by a test
              # we have tests in spec/flows/under_eighteen_flow_spec.rb that check with and without under_eighteen_assets
              # :nocov:
              (Sections::ClientIncome.new(check) if !check.under_eighteen? || check.aggregated_means? || check.under_eighteen_regular_income? || check.under_eighteen_assets?),
              # :nocov:
            ].compact

            post = [Sections::Outgoings.new(check)]
            finance_sections = if check.partner?
                                 pre + [Sections::PartnerIncome.new(check)] + post
                               else
                                 pre + post
                               end
            assets_sections = assets

            non_finance_sections + finance_sections + assets_sections
          end
        end
      end
    end
  end
end
