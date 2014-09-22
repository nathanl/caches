require 'time'
require_relative 'accessible'

module Caches
  class TTL
    include Accessible
    attr_accessor :ttl, :refresh

    def initialize(options = {})
      self.ttl      = options.fetch(:ttl) { 3600 }
      self.refresh  = !!(options.fetch(:refresh, false))
      self.data     = {}
      self.nodes    = LinkedList.new
      self.max_keys = options[:max_keys]
    end

    def [](key)
      return nil unless data.has_key?(key)
      if current?(key) 
        data[key][:value].tap {
          data[key][:time] = current_time if refresh
        }
      else
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
      keys.length
    end

    def keys
      data.keys
    end

    def values
      data.values.map { |h| h.fetch(:value) }
    end

    private

    def current?(key)
      (current_time - data[key][:time]) < ttl
    end

    def expired?(key)
      !current?(key)
    end

    def full?
      max_keys && size >= max_keys
    end

    attr_accessor :data, :nodes, :max_keys

    def current_time
      Time.now
    end

  end
end
