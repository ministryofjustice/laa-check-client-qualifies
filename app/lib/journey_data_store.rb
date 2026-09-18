class JourneyDataStore
  class KeyNotFound < StandardError; end

  # Standalone mode: session-backed (existing behaviour)
  class SessionStore
    def initialize(session, resource_id)
      @session = session
      @resource_id = resource_id
    end

    def read
      @session[@resource_id] || raise(KeyNotFound)
    end

    def write(data)
      @session[@resource_id] = data
    end

    def init(data = {})
      @session[@resource_id] ||= data
    end

    def delete
      @session.delete(@resource_id)
    end
  end

  # Embedded mode: Redis-backed via Rails.cache
  class RedisStore
    CACHE_KEY_PREFIX = "embedded-journey-data".freeze

    def initialize(resource_id, session_id)
      @resource_id = resource_id
      @session_id = session_id
    end

    def read
      Rails.cache.read(cache_key) || raise(KeyNotFound)
    end

    def write(data)
      Rails.cache.write(cache_key, data, expires_in: 12.hours)
    end

    def init(data = {})
      write(data) unless Rails.cache.exist?(cache_key)
    end

    def delete
      Rails.cache.delete(cache_key)
    end

  private

    def cache_key
      raise KeyNotFound if @session_id.blank?

      session_digest = Digest::SHA256.hexdigest([@resource_id, @session_id].join("\0"))
      "#{CACHE_KEY_PREFIX}:#{session_digest}"
    end
  end
end
