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
      # with this version, the only test that fails is early_result_change_answers_flow_spec.rb:191
      # which fails as the ClientIncome section is present when it shouldn't be.
      # Again these sections should be shown iff the relevant data is filled out
      #
      # currently the flow (early eligibility) determines whether this data is shown or not by collapsing all the tables
      # each table should be collapsible via employment yes/no, benefits yes/no, other income yes/no
      # same for partner income
      # tables = possible_tables
      tables = possible_tables.select { Steps::Helper.relevant_steps(@check.session_data).include?(_1.screen) }
      Subsection.new(tables:) if tables.any?
    end
  end
end
