module Cfe
  class BaseService
    class << self
      def BaseService.instantiate_form(session_data, form_class)
        form_class.model_from_session(session_data).tap do |form|
          raise Cfe::InvalidSessionError, form unless form.valid?
        end
      end

      def completed_form?(completed_steps, form_name)
        completed_steps.include?(form_name)
      end
    end
  end
end
