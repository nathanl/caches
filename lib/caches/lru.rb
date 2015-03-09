require_relative 'accessible'
require_relative 'linked_list'
require_relative 'stats'

module Caches
  class LRU
    include Accessible
    prepend Stats
    attr_accessor :max_keys

    attr_accessor :keys, :data
    private       :keys, :data

    def initialize(options = {})
      self.max_keys = options.fetch(:max_keys, 20)
      self.data     = {}
      self.keys     = LinkedList.new
    end

    def [](key)
      return nil if max_keys.zero?
      unless data.has_key?(key)
        record_cache_miss
        return nil 
      end
      record_cache_hit
      value, node = data[key]
      keys.move_to_head(node)
      value
    end

    def []=(key, val)
      return nil if max_keys.zero?
      if data.has_key?(key)
        data[key][0] = val
      else
        node = keys.prepend(key)
        data[key] = [val, node]
      end
      prune
      val
    end

    def size
      keys.length
    end

    private

    def prune
      return unless keys.length > max_keys
      expiring_node = keys.pop
      data.delete(expiring_node.value)
    end

  end
end
