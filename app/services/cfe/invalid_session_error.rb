module Cfe
  class InvalidSessionError < StandardError
    def initialize(form)
      message = "Invalid session detected by #{form.class}:\n  #{form.errors.full_messages.join("\n  ")}"
      super(message)
    end
  end
end
