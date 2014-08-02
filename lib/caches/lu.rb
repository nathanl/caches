require          'time'
require_relative 'accessible'
require_relative 'linked_list'

module Caches
  class LU
    include Accessible

    class Datum
      include Comparable

      attr_accessor :value, :created_at

      def initialize(value, created_at)
        self.value      = value
        self.created_at = created_at
        @uses           = 0
      end

      def use
        @uses += 1
        value
      end

      def utility
        # Uses per second
        uses / (current_time - created_at)
      end

      def uses
        @uses
      end

      def <=>(other)
        return unless other.is_a?(self.class)
        utility <=> other.utility
      end

      private

      def current_time
        Time.now
      end

    end

  end
end
