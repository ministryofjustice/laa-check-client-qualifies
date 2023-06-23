module Cfe
  class DependantsPayloadService < BaseService
    def call
      return unless relevant_form?(:dependant_details)

      details_form = instantiate_form(DependantDetailsForm)
      children = CfeParamBuilders::Dependants.children(dependants: details_form.child_dependants,
                                                       count: details_form.child_dependants_count)
      adults = CfeParamBuilders::Dependants.adults(dependants: details_form.adult_dependants,
                                                   count: details_form.adult_dependants_count)
      dependants = children + adults
      payload[:dependants] = dependants
    end
  end
end
