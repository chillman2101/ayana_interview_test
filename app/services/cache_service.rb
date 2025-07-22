class CacheService
  class << self
    def fetch(key, expires_in: 10.minutes)
      Rails.cache.fetch(key, expires_in: expires_in) do
        yield if block_given?
      end
    end

    def invalidate(key)
      Rails.cache.delete(key)
    end
  end
end
