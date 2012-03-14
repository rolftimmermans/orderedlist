module OrderedList
  class Position
    # Raised if trying to calculate an intermediate position between two
    # equal positions.
    class EqualPositions < StandardError; end

    # Allows computation of a new position between to other positions.
    module Intermediable
      # Calculates a new position between this position and the given other
      # position. The intermediate position may either be a common ancestor,
      # or an ancestor of one and a descendant of the other, or a child of one
      # and a descendant of the other. The new position is the shortest one
      # possible between the two positions (without renumbering). An
      # EqualPositions exception is raised if the two positions are equal.
      def between(other)
        # Guarantee that self is the shorter position of the two.
        return other.between(self) if length > other.length

        # Find common ancestor of both positions.
        short, long = to_enum, other.to_enum
        intermediate = ancestor_of_enums(short, long)

        # Stop and return common ancestor if both paths have more digits.
        return intermediate unless enum_end?(short)

        # Raise error if neither paths have more digits -- they are equal.
        raise EqualPositions, "Cannot create intermediate between equal positions" if enum_end?(long)

        # Check the direction of the longest path after the split from the
        # common ancestor.
        intermediate << (direction = long.next)

        # Append digits of longest path until direction changes.
        loop do
          break if long.peek == direction
          intermediate << long.next
        end

        # If we're at the end of the path, append opposite of initial
        # direction to create a new child.
        intermediate << (1 ^ direction) if enum_end?(long)

        # Return the new intermediate position.
        intermediate
      end

      private

      # Creates and returns a new position based on the common ancestor of the
      # given bit array enumerators. The enumerators are guaranteed to be at
      # the position directly after the common ancestor has been found.
      def ancestor_of_enums(one, other)
        Position.new.tap do |ancestor|
          loop do
            break unless one.peek == other.peek
            ancestor << (one.next & other.next)
          end
        end
      end

      # Returns true iff the given enum has reached the end.
      def enum_end?(enum)
        enum.peek
        false
      rescue
        true
      end
    end
  end
end
