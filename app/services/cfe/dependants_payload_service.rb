module Cfe
  class DependantsPayloadService < BaseService
    def call
      return if check.passported? || check.non_means_tested?

      details_form = instantiate_form(DependantDetailsForm)
      payload[:dependants] = CfeParamBuilders::Dependants.call(details_form, check.dependant_incomes)
    end
  end
end
