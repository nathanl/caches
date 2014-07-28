module Caches
  # This LinkedList class is unusual in that it gives direct access to its nodes.
  # It trusts the user not to break it! The advantage is that outsiders with
  # a node reference can reorder the list (eg, using #move_to_head) in O(1) time.
  class LinkedList
    include Enumerable

    attr_reader :length

    def initialize(item = nil)
      if item
        Node.new(item).tap { |node|
          self.head   = self.tail = node
          self.length = 1
        }
      else
        self.length = 0
      end
    end

    def each
      current = head
      while current do
        yield(current.value)
        current = current.right
      end
    end

    def append(item)
      return initialize(item) if empty?
      Node.new(item, left: tail).tap { |new_tail|
        tail.right = new_tail
        self.tail  = new_tail
        self.length = length + 1
      }
    end

    def prepend(item)
      return initialize(item) if empty?
      Node.new(item, right: head).tap { |new_head|
        head.left = new_head
        self.head = new_head
        self.length = length + 1
      }
    end
    alias :unshift :prepend

    def pop
      tail.tap {
        new_tail       = tail.left
        new_tail.right = nil
        self.tail      = new_tail
        self.length = length - 1
      }
    end

    def lpop
      head.tap {
        new_head      = head.right
        new_head.left = nil
        self.head     = new_head
        self.length = length - 1
      }
    end
    alias :shift :lpop

    def move_to_head(node)
      excise(node)
      node.right = head
      self.head  = node
    end

    def empty?
      length == 0
    end

    # TODO - move these to a module and use in caches, too
    alias :blank? :empty?
    def present?
      !empty?
    end
    def presence
      self if present?
    end

    private
    attr_accessor :head, :tail
    attr_writer   :length

    def excise(node)
      raise InvalidNode unless node.is_a?(Node)
      left       = node.left
      right      = node.right
      left.right = right unless left.nil?
      right.left = left  unless right.nil?
      self.head  = right if head == node
      self.tail  = left  if tail == node
      node
    end

    class Node
      attr_accessor :value, :right, :left
      def initialize(value, pointers = {})
        self.value = value
        self.right = pointers[:right]
        self.left  = pointers[:left]
      end

      def right?; !right.nil?; end
      def left?;  !left.nil?   end
    end

    InvalidNode = Class.new(StandardError)
  end
end
