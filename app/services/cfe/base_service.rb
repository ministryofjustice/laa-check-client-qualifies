module Cfe
  class BaseService
    def self.call(session_data, payload, completed_steps)
      new(session_data, payload, completed_steps).call
    end

    def initialize(session_data, payload, completed_steps)
      @session_data = session_data
      @payload = payload
      @completed_steps = completed_steps
    end

  private

    def instantiate_form(form_class)
      form = form_class.from_session(@session_data)
      raise Cfe::InvalidSessionError, form unless form.valid?

      form
    end

    attr_reader :payload, :completed_steps

    def check
      @check ||= Check.new(@session_data)
    end

    def completed_form?(form_name)
      completed_steps.include?(form_name)
    end
  end
end
