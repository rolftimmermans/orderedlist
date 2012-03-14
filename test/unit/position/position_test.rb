require File.expand_path("../../../test_helper", __FILE__)

describe "position" do
  it "should respond to each" do
    assert Position.new.respond_to?(:each)
  end

  describe "parse" do
    it "should parse given string without trailing one" do
      assert_equal [0, 1, 1, 0], Position.parse("01101").to_a
    end

    it "should parse given string while ignoring additional bits" do
      assert_equal [0, 1, 1, 0], Position.parse("23547").to_a
    end

    it "should yield each digit when calling each" do
      assert_equal [0, 1, 1, 0], Position.parse("01101").each.to_a
    end

    it "should ignore trailing zeroes when parsing" do
      assert_equal [0, 1], Position.parse("01100").to_a
    end
  end

  describe "to s" do
    it "should return encoded string with trailing one" do
      assert_equal "011011", Position.new([0, 1, 1, 0, 1]).to_s
    end
  end

  describe "push" do
    it "should append binary digit" do
      assert_equal pos("01001"), pos("0101") << 0
    end
  end

  describe "length" do
    it "should return length of bit string without trailing one" do
      assert_equal 3, pos("0101").length
    end
  end

  describe "when comparing" do
    it "should be smaller than right sibling" do
      assert pos("01101") < pos("01111")
    end

    it "should be greater than left sibling" do
      assert pos("01111") > pos("01101")
    end

    it "should be smaller than parent of left leaf" do
      assert pos("01101") < pos("0111")
    end

    it "should be greater than parent of right leaf" do
      assert pos("01111") > pos("0111")
    end

    it "should be equal to self with trailing zeroes" do
      assert pos("01111") == pos("01111000")
    end

    it "should not be equal to other position" do
      assert pos("11011") != pos("0110")
    end
  end
end
