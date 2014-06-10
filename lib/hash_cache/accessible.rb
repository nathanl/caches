module HashCache
  module Accessible

    def fetch(key, default = (default_omitted = true; nil))
      return self[key]  if data.has_key?(key)
      return yield(key) if block_given?
      return default    unless default_omitted
      raise KeyError
    end

    def memoize(key)
      raise ArgumentError, "Block is required" unless block_given?
      self[key] # triggers flush or refresh if expired
      return self[key]       if data.has_key?(key)
      self[key] = yield(key) if block_given?
    end

  end
end
