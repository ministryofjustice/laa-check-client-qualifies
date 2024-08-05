module Cfe
  class DependantsPayloadService
    class << self
      def call(session_data, payload)
        check = Check.new session_data
        return if check.passported? || check.non_means_tested?

        details_form = BaseService.instantiate_form(session_data, DependantDetailsForm)
        payload[:dependants] = CfeParamBuilders::Dependants.call(details_form, check.dependant_incomes)
      end
    end
  end
end
