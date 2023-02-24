class ErrorService
  class << self
    def call(exception)
      if FeatureFlags.enabled?(:sentry)
        Sentry.capture_exception(exception)
      else
        ExceptionNotifier::TemplatedNotifier.new.call(exception)
      end
    end
  end
end
