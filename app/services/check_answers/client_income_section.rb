# frozen_string_literal: true

module CheckAnswers
  class ClientIncomeSection
    def initialize(check)
      @check = check
    end

    def label
      :client_income
    end

    def subsections
      [
        subsection_for(EmploymentSubsection.tables(check: @check,
                                                   status_field_name: :employment_status,
                                                   incomes: @check.incomes,
                                                   income_field_name: :income)),
        subsection_for(BenefitsSubsection.tables(check: @check,
                                                 status_field_name: :benefits,
                                                 status_attribute_name: :receives_benefits,
                                                 benefits: @check.benefits,
                                                 benefits_field_name: :benefit_details)),
        subsection_for(OtherIncomeSubsection.tables(check: @check,
                                                    other_income_field: :other_income,
                                                    attribute_prefix: "")),
      ].compact
    end

  private

    def subsection_for(possible_tables)
      tables = possible_tables.select { Steps::Helper.relevant_steps(@check.session_data).include?(_1.screen) }
      Subsection.new(tables:) if tables.any?
    end
  end
end
