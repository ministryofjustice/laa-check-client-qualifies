module Cfe
  class BaseService
    def self.call(cfe_connection, cfe_assessment_id, session_data)
      new(cfe_connection, session_data).call(cfe_assessment_id)
    end

    def initialize(cfe_connection, session_data)
      @cfe_connection = cfe_connection
      @session_data = session_data
    end

  protected

    attr_reader :cfe_connection

    def check
      @check ||= Check.new(@session_data)
    end

    def relevant_form?(form_name)
      StepsHelper.valid_step?(@session_data, form_name)
    end
  end
end
