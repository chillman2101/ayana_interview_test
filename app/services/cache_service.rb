class CacheService
  class << self
    def fetch_cache(key, expires_in: 5.minutes)
      Rails.cache.fetch(key, expires_in: expires_in) do
        yield if block_given?
      end
    end

    def invalidate(key)
      Rails.cache.delete(key)
    end
  end
end
