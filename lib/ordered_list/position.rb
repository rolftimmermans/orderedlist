require "ordered_list/position/intermediable"
require "ordered_list/position/boundary"

module OrderedList
  # A position indicates the location of a record within an ordered list. It
  # is represented as a path in a binary tree. The path is encoded as a bit
  # array or bit string, which can be stored in a database field.
  class Position
    include Enumerable
    include Comparable
    include Intermediable

    delegate :each, :length, to: :@bit_array

    class << self
      ASCII_OFFSET = "0".ord

      # Parses the given bit string and returns a corresponding position
      # object. Any trailing zeroes are ignored. The last one marks the end
      # of the bit string and does not belong to the binary tree path.
      def parse(string)
        # Convert bit string to bit array, with each bit encoded as Fixnum.
        # This is faster than calling to_i on each substring.
        bit_array = string.each_byte.map { |b| b - ASCII_OFFSET & 1 }

        # Remove any trailing zeroes and the trailing one that marks the end
        # of the bit array.
        loop until bit_array.pop == 1

        new bit_array
      end
    end

    # Create a new position given a bit array that represents a path in a
    # binary tree. If no bit array is given the position represents the root
    # of the binary tree.
    def initialize(bit_array = [])
      @bit_array = bit_array
    end

    # Appends a binary digit (represented as 0 or 1) to the end of the binary
    # tree path.
    def <<(digit)
      @bit_array << digit
      self
    end

    # Compare this position with the given other position. Comparison is
    # performed by comparing the encoded bit string representations of the
    # binary tree path in lexicographic order.
    def <=>(other)
      self.encoded_bit_array <=> other.encoded_bit_array
    end

    # Returns the bit string that corresponds to this position. The bit string
    # is an encoded form of the binary tree path, marked with a trailing one.
    # The trailing one ensures that lexicographic comparison of bit strings
    # corresponds to in-order tree traversal.
    def to_s
      encoded_bit_array.join(&:to_s)
    end

    protected

    # Returns the bit array that corresponds to this position, including
    # trailing one.
    def encoded_bit_array
      # Append trailing one for easy sorting between binary paths of
      # different lengths.
      @bit_array + [1]
    end
  end
end
