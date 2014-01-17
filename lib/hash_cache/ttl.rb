module HashCache
  class TTL
    attr_accessor :ttl, :refresh

    def initialize(options = {})
      self.ttl     = options.fetch(:ttl) { 3600 }
      self.refresh = !!(options.fetch(:refresh, false))
      self.data    = {}
    end

    def [](key)
      return nil unless data.has_key?(key)
      if (current_time - data[key][:time]) < ttl
        data[key][:time] = current_time if refresh
        data[key][:value]
      else
        data.delete(key)
        nil
      end
    end

    def []=(key, val)
      data[key] = {time: current_time, value: val}
    end

    def fetch(key, default = (default_omitted = true; nil))
      return self[key]  if data.has_key?(key)
      return default    unless default_omitted
      return yield(key) if block_given?
      raise KeyError
    end

    def memoize(key)
      raise ArgumentError, "Block is required" unless block_given?
      self[key] # triggers flush or refresh if expired
      return self[key]       if data.has_key?(key)
      self[key] = yield(key) if block_given?
    end

    private

    attr_accessor :data

    def current_time
      Time.now
    end

  end
end
