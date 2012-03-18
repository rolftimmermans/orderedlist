require File.expand_path("../../../test_helper", __FILE__)

describe "position" do
  it "should respond to each" do
    assert Position.new("\x80").respond_to?(:each)
  end

  describe "length" do
    it "should be zero for root" do
      assert_equal 0, Position.new("\x80").length
    end

    it "should be seven for string with one byte with rightmost bit set" do
      assert_equal 7, Position.new("}").length
    end

    it "should be eight times number of bytes minus trailing zero bytes and trailing bit" do
      assert_equal 31, Position.new("AAA}\x00\x00").length
    end

    it "should be eight times number of bytes with trailing bit in next byte" do
      assert_equal 32, Position.new("AAA}\x80").length
    end

    it "should be eight times number of bytes minus trailing unset bits and trailing bit" do
      assert_equal 25, Position.new("AAA@").length
    end
  end

  describe "new" do
    it "should fail for empty string" do
      assert_raises ArgumentError do
        Position.new("")
      end
    end

    it "should fail for null bytes" do
      assert_raises ArgumentError do
        Position.new("\x00\x00")
      end
    end

    it "should parse given string without trailing one" do
      assert_equal [0, 1, 0, 0, 0, 0, 0], Position.new("A").to_a
    end

    it "should parse given string without trailing zero bits" do
      assert_equal [0], Position.new("@").to_a
    end

    it "should parse given string without trailing zero bytes" do
      assert_equal [0, 1, 1, 1, 1, 1, 0], Position.new("}\x00\x00").to_a
    end
  end

  describe "encode" do
    it "should return encoded string with trailing one" do
      assert_equal "}", Position.new("}").to_bin
    end

    it "should return encoded string without trailing null bytes" do
      assert_equal "A@", Position.new("A@\x00\x00").to_bin
    end

    it "should return binary string" do
      assert_equal Encoding.find("binary"), Position.new("\xc2\xa2".force_encoding("utf-8")).to_bin.encoding
    end
  end

  describe "to_s" do
    it "should return base encoded string with trailing one" do
      assert_equal "7d", Position.new("}").to_s
    end

    it "should return base encoded encoded string without trailing null bytes" do
      assert_equal "4140", Position.new("A@\x00\x00").to_s
    end
  end

  describe "push" do
    it "should append zero and shift trailing one" do
      assert_equal binpos("1001"), binpos("101") << 0
    end

    it "should append zero and shift trailing one to last position" do
      assert_equal binpos("11010101"), binpos("1101011") << 0
    end

    it "should append zero and carry trailing one" do
      assert_equal binpos("110101001"), binpos("11010101") << 0
    end

    it "should append one and shift trailing one" do
      assert_equal binpos("1011"), binpos("101") << 1
    end

    it "should append one and shift trailing one to last position" do
      assert_equal binpos("11010111"), binpos("1101011") << 1
    end

    it "should append one and carry trailing one" do
      assert_equal binpos("110101011"), binpos("11010101") << 1
    end

    it "should append repeated digits to form new position" do
      assert_equal binpos("110110101101000111"),
        Position.new << 1 << 1 << 0 << 1 << 1 << 0 << 1 << 0 << 1 << 1 << 0 << 1 << 0 << 0 << 0 << 1 << 1
    end
  end

  describe "when comparing" do
    it "should be smaller than right sibling" do
      assert binpos("01101") < binpos("01111")
    end

    it "should be greater than left sibling" do
      assert binpos("01111") > binpos("01101")
    end

    it "should be smaller than parent of left leaf" do
      assert binpos("01101") < binpos("0111")
    end

    it "should be greater than parent of right leaf" do
      assert binpos("01111") > binpos("0111")
    end

    it "should be equal to same position" do
      assert binpos("01111") == binpos("01111000")
    end

    it "should be equal to some position with trailing zeroes" do
      assert binpos("01111") == binpos("01111000")
    end

    it "should not be equal to other position" do
      assert binpos("11011") != binpos("0110")
    end
  end
end
