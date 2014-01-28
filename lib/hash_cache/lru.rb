require_relative 'accessible'
require_relative 'linked_list'

module HashCache
  class LRU
    include Accessible
    attr_accessor :max_keys

    def initialize(options = {})
      self.max_keys = options.fetch(:max_keys, 20)
      self.data     = {}
      self.keys = LinkedList.new
    end

    def [](key)
      return nil unless data.has_key?(key)
      value, node = data[key]
      keys.move_to_head(node)
      value
    end

    def []=(key, val)
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
    attr_accessor :keys, :data

    def prune
      return unless keys.length > max_keys
      expiring_node = keys.pop
      data.delete(expiring_node.value)
    end

  end
end
