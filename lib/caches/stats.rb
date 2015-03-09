module Caches
  module Stats

    def initialize(*args)
      @hits   = 0
      @misses = 0
      super
    end

    def stats
      {hits: @hits, misses: @misses, hit_rate: hit_rate}
    end

    private

    def record_cache_hit
      @hits += 1
    end

    def record_cache_miss
      @misses += 1
    end

    def hit_rate
      rate = (Float(@hits) / (Float(@hits) + Float(@misses)))
      "#{rate * 100}%"
    end

  end
end
