# This module is like SessionPersistable except that it expects that, instead of mapping between
# model attributes and session attributes directly, the session equivalent of each model
# attribute will be prefixed with `partner_`.
module SessionPersistableForPartner
  extend ActiveSupport::Concern
  include SessionPersistable

  class_methods do
    def attributes_from_session(session_data)
      session_attributes = session_data.slice(*session_keys)
      session_attributes.transform_keys { _1.gsub("partner_", "") }
    end

    def session_keys
      self::ATTRIBUTES.map { "partner_#{_1}" }
    end
  end

  def session_attributes
    attributes.transform_keys { "partner_#{_1}" }
  end
end
