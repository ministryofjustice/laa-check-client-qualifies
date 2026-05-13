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
    def initialize(resource_id)
      @resource_id = resource_id
    end

    def read
      Rails.cache.read(@resource_id) || raise(KeyNotFound)
    end

    def write(data)
      Rails.cache.write(@resource_id, data, expires_in: 14.days)
    end

    def init(data = {})
      write(data) unless Rails.cache.exist?(@resource_id)
    end

    def delete
      Rails.cache.delete(@resource_id)
    end
  end
end
