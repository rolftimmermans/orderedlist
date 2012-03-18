require "ordered_list/position/intermediable"
require "ordered_list/position/boundary"

module OrderedList
  # A position indicates the location of a record within an ordered list. It
  # is represented as a path in a binary tree.
  class Position
    include Enumerable
    include Comparable
    include Intermediable

    # Create a new position given a bit string that represents a path in a
    # binary tree, marked with a trailing one.
    def initialize(bytestr = "\x80")
      @bytestr = bytestr.force_encoding("binary").sub(/\x00*$/, "")
      raise ArgumentError, "Empty string is not a tree path" if @bytestr.empty?
    end

    # Returns the length of the binary tree path, excluding the trailing bit.
    def length
      8 * bytestr.bytesize - trailing_bit_offset - 1
    end

    # Iterates over all bits in the binary tree path, yielding either a 0 or
    # a 1. It does not yield the trailing bit that marks the end of the binary
    # tree path.
    def each
      0.upto(length - 1) do |i|
        yield self[i]
      end
    end

    # Appends a binary digit (represented as 0 or 1) to the end of the binary
    # tree path.
    def <<(digit)
      byteindex, bitindex = length.divmod(8)

      # Create a bit mask for the bit that needs to be set or unset.
      mask = 128 >> bitindex
      value = bytestr[byteindex].ord

      # Set or unset last bit with some classic bit twiddling.
      if digit == 1
        value |= mask
      else
        value &= ~mask
      end

      # Set the next bit to one to indicate end of the binary tree path.
      if bitindex < 7
        value |= mask >> 1
      else
        bytestr << "\x80"
      end

      bytestr[byteindex] = value.chr
      self
    end

    # Compare this position with the given other position. Comparison is
    # performed by comparing the encoded binary string representations of the
    # binary tree path in lexicographic order.
    def <=>(other)
      bytestr <=> other.bytestr
    end

    # Returns the binary string that corresponds to this position. The string
    # is an encoded form of the binary tree path, marked with a trailing bit.
    # The trailing bit ensures that lexicographic comparison of binary strings
    # corresponds to in-order tree traversal.
    def to_bin
      bytestr
    end

    # Returns a hexadecimal representation of the binary path.
    def to_s
      bytestr.unpack("H*").first
    end

    protected

    # Internal representation of the binary path.
    attr_reader :bytestr

    # Returns the bit at a given index.
    def [](index)
      byteindex, bitindex = index.divmod(8)
      bytestr[byteindex].ord[7 - bitindex]
    end

    private

    # Offset of the trailing one bit in the last byte from the right.
    def trailing_bit_offset
      byte = bytestr[-1].ord
      8.times do |i|
        return i if byte[i] == 1
      end
    end
  end
end
