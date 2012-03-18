module OrderedList
  class Position
    # Boundary positions are the minimum or maximum positions in any list.
    # They are represented by an infinite bit array that represents a path
    # at the extreme ends of an infinite binary tree.

    # TODO: Do we need a different algorithm at the sides of the tree to
    # create a new path? In that case we can remove this class.
    class Boundary
      include Enumerable
      include Intermediable

      def initialize(bit)
        @bit = bit
      end

      def length
        Float::INFINITY
      end

      def each
        loop do
          yield @bit
        end
      end

      def to_s
        (@bit == 1 ? "f" : "0") * 4 + "..."
      end
    end

    # The limit of the left side of the binary tree.
    MIN = Boundary.new(0)

    # The limit of the right side of the binary tree.
    MAX = Boundary.new(1)
  end
end
