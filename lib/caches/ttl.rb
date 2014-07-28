require_relative 'accessible'

module Caches
  class TTL
    include Accessible
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

    def size
      data.keys.length
    end

    private

    attr_accessor :data

    def current_time
      Time.now
    end

  end
end
