module Cfe
  class BaseService
    def self.call(*args, payload)
      new(*args, payload).call
    end

    def initialize(*args, payload)
      @session_data, @early_eligibility = *args
      @payload = payload
    end

  private

    def instantiate_form(form_class)
      form = form_class.from_session(@session_data)
      raise Cfe::InvalidSessionError, form unless form.valid?

      form
    end

    attr_reader :payload, :early_eligibility

    def check
      @check ||= Check.new(@session_data)
    end

    def relevant_form?(form_name, form_class = nil)
      if FeatureFlags.enabled?(:early_eligibility, @session_data) && form_class
        Steps::Helper.valid_step?(@session_data, form_name) && form_class.from_session(@session_data).valid?
      else
        Steps::Helper.valid_step?(@session_data, form_name)
      end
    end

    def early_gross_income_check?
      @early_eligibility == :gross_income
    end
  end
end
