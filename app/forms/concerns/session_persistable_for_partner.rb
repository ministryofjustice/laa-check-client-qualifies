# This module is like SessionPersistable except that it expects that, instead of mapping between
# model attributes and session attributes directly, the session equivalent of each model
# attribute will be prefixed with `partner_`.
module SessionPersistableForPartner
  extend ActiveSupport::Concern

  class_methods do
    def from_session(session_data)
      session_keys = self::ATTRIBUTES.map(&:to_s).map { "partner_#{_1}" }
      session_attributes = session_data.slice(*session_keys)
      transformed_session_attributes = session_attributes.transform_keys { _1.gsub("partner_", "") }
      new(transformed_session_attributes)
    end
  end

  def session_attributes
    attributes.transform_keys { "partner_#{_1}" }
  end
end
