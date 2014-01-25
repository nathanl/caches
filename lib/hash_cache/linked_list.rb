module HashCache
  class LinkedList
    include Enumerable

    def initialize(item)
      self.head = self.tail = Node.new(item)
    end

    def each
      current = head
      while current do
        yield(current.value)
        current = current.right
      end
    end

    def append(item)
      new_tail   = Node.new(item, tail)
      tail.right = new_tail
      self.tail  = new_tail
    end

    def prepend(item)
      new_head  = Node.new(item, nil, head)
      head.left = new_head
      self.head = new_head
    end
    alias :unshift :prepend
    
    def pop
      tail.value.tap {
        new_tail       = tail.left
        new_tail.right = nil
        self.tail      = new_tail
      }
    end

    def lpop
      head.value.tap {
        new_head      = head.right
        new_head.left = nil
        self.head     = new_head
      }
    end
    alias :shift :lpop

    private
    attr_accessor :head, :tail

    Node = Struct.new(:value, :left, :right) do
      def right?; !right.nil?; end
      def left?;  !left.nil?   end
    end
  end
end
