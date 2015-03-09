require 'time'
require_relative 'accessible'
require_relative 'linked_list'
require_relative 'stats'

module Caches
  class TTL
    include Accessible
    prepend Stats
    attr_accessor :ttl, :refresh

    attr_accessor :data, :nodes, :max_keys
    private       :data, :nodes, :max_keys

    def initialize(options = {})
      self.ttl      = options.fetch(:ttl) { 3600 }
      self.refresh  = !!(options.fetch(:refresh, false))
      self.max_keys = options[:max_keys]
      initialize_data
    end

    def [](key)
      unless data.has_key?(key)
        record_cache_miss
        return nil
      end
      if current?(key)
        record_cache_hit
        data[key][:value].tap {
          data[key][:time] = current_time if refresh
        }
      else
        record_cache_miss
        delete(key)
        nil
      end
    end

    def []=(key, val)
      if data.has_key?(key)
        node = data[key][:node]
        nodes.move_to_head(node)
      else
        if full?
          evicted_node = nodes.pop
          data.delete(evicted_node.value)
        end
        node = nodes.prepend(key)
      end
      data[key] = {time: current_time, value: val, node: node}
    end

    def delete(key)
      node = data[key][:node]
      nodes.delete(node)
      hash = data.delete(key)
      hash.fetch(:value)
    end

    def size
      nodes.length
    end

    def keys
      data.keys
    end

    def values
      data.values.map { |h| h.fetch(:value) }
    end

    def clear
      initialize_data
    end

    private

    def initialize_data
      self.data     = {}
      self.nodes    = LinkedList.new
      self
    end

    def current?(key)
      (current_time - data[key][:time]) < ttl
    end

    def expired?(key)
      !current?(key)
    end

    def full?
      max_keys && size >= max_keys
    end

    def current_time
      Time.now
    end

  end
end
