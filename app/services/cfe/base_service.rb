module Cfe
  class BaseService
    def self.call(session_data, payload, relevant_steps)
      new(session_data, payload, relevant_steps).call
    end

    def initialize(session_data, payload, relevant_steps)
      @session_data = session_data
      @payload = payload
      @relevant_steps = relevant_steps
    end

  private

    def instantiate_form(form_class)
      form = form_class.from_session(@session_data)
      raise Cfe::InvalidSessionError, form unless form.valid?

      form
    end

    attr_reader :payload, :relevant_steps

    def check
      @check ||= Check.new(@session_data)
    end

    def relevant_form?(form_name)
      relevant_steps.include?(form_name)
    end
  end
end
