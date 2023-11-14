module Cfe
  class BaseService
    def self.call(session_data, payload, early_eligibility)
      new(session_data, payload, early_eligibility).call
    end

    def initialize(session_data, payload, early_eligibility)
      @session_data = session_data
      @payload = payload
      @early_eligibility = early_eligibility
    end

  private

    def instantiate_form(form_class)
      form = form_class.from_session(@session_data)
      raise Cfe::InvalidSessionError, form unless form.valid?

      form
    end

    attr_reader :payload

    def check
      @check ||= Check.new(@session_data)
    end

    def relevant_form?(form_name)
      Steps::Helper.valid_step?(@session_data, form_name)
    end

    def early_gross_income_result?
      @early_eligibility == :gross_income
    end

    def early_eligibility?
      !@early_eligibility.nil?
    end
  end
end
