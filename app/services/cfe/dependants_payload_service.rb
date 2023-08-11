module Cfe
  class DependantsPayloadService < BaseService
    def call
      return unless relevant_form?(:dependant_details)

      details_form = instantiate_form(DependantDetailsForm)
      payload[:dependants] = CfeParamBuilders::Dependants.call(details_form, check.dependant_incomes)
    end
  end
end
