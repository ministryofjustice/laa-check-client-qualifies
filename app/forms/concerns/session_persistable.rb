# This module allows a model object to populate itself from a session object with or without some params,
# and also to translate its values into attributes to go into the session.
module SessionPersistable
  extend ActiveSupport::Concern

  included do
    attr_reader :check
  end

  def initialize(attributes = {}, check = nil)
    @check = check
    super(attributes)
  end

  class_methods do
    def from_session(session_data)
      check = Check.new(session_data)
      new(attributes_from_session(session_data), check)
    end

    def from_params(params, session_data)
      check = Check.new(session_data)
      new(attributes_from_params(params), check)
    end

    def attributes_from_session(session_data)
      session_data.slice(*session_keys)
    end

    def attributes_from_params(params)
      params.fetch(name.underscore, {}).permit(*self::ATTRIBUTES)
    end

    def session_keys
      self::ATTRIBUTES.map(&:to_s)
    end
  end

  def session_attributes
    attributes
  end
end
