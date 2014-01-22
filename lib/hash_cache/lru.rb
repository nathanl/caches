require_relative 'accessible'

module HashCache
  class LRU
    include Accessible
    attr_accessor :max_keys

    def initialize(options = {})
      self.max_keys = options.fetch(:max_keys, 20)
      self.data     = {}
      self._keys    = []
    end

    def [](key)
      return nil unless data.has_key?(key)
      _keys.unshift(_keys.delete_at(_keys.index(key)))
      data[key]
    end

    def []=(key, val)
      _keys.unshift(key)
      data[key] = val
      if _keys.length > max_keys
        expiring_key = _keys.pop
        data.delete(expiring_key)
      end
      val
    end

    def size
      _keys.length
    end

    private
    attr_accessor :_keys, :data

  end
end
