# This module allows a model object to populate itself from a session object with or without some params,
# and also to translate its values into attributes to go into the session.
module SessionPersistable
  extend ActiveSupport::Concern

  included do
    attr_reader :estimate
  end

  def initialize(attributes = {}, estimate = nil)
    @estimate = estimate
    super(attributes)
  end

  class_methods do
    def from_session(session_data)
      estimate = EstimateModel.from_session(session_data)
      new(attributes_from_session(session_data), estimate)
    end

    def from_params(params, session_data)
      estimate = EstimateModel.from_session(session_data)
      new(attributes_from_params(params), estimate)
    end

    def attributes_from_session(session_data)
      session_data.slice(*self::ATTRIBUTES.map(&:to_s))
    end

    def attributes_from_params(params)
      params.fetch(name.underscore, {}).permit(*self::ATTRIBUTES)
    end
  end

  def session_attributes
    attributes
  end
end
