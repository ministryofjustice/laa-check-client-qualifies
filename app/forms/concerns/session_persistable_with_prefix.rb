module SessionPersistableWithPrefix
  extend ActiveSupport::Concern
  include SessionPersistable
  class_methods do
    def extract_simple_attributes_from_session(session_data)
      session_attributes = session_data.slice(*session_keys)
      session_attributes.transform_keys { _1.gsub(self::PREFIX, "") }
    end

    def session_keys
      self::ATTRIBUTES.map { "#{self::PREFIX}#{_1}" }
    end
  end

  def simple_attributes_for_session
    attributes.transform_keys { "#{self.class::PREFIX}#{_1}" }
  end
end
