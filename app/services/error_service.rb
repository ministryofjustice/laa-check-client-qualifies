class ErrorService
  class << self
    def call(exception)
      if FeatureFlags.enabled?(:sentry, without_session_data: true)
        Sentry.capture_exception(exception)
      else
        ExceptionNotifier::TemplatedNotifier.new.call(exception)
      end
    end
  end
end
