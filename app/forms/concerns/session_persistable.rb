# This module allows a model object to populate itself from a session object with or without some params,
# and also to translate its values into attributes to go into the session.
module SessionPersistable
  extend ActiveSupport::Concern

  class_methods do
    def from_session(session_data)
      new(session_data.slice(*self::ATTRIBUTES.map(&:to_s)))
    end

    def from_params(params, _session)
      relevant_params = params.fetch(name.underscore, {}).permit(*self::ATTRIBUTES)
      new(relevant_params)
    end
  end

  def session_attributes
    attributes
  end
end
