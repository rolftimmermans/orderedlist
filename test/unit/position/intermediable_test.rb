require File.expand_path("../../../test_helper", __FILE__)

describe "intermediable" do
  describe "between" do
    it "should raise error if calculating position between equal positions" do
      assert_raises Position::EqualPositions do
        binpos("001101").between(binpos("001101"))
      end
    end

    it "should return new grandchild between parent and left child" do
      assert_equal binpos("0110101"), binpos("01101").between(binpos("011011"))
    end

    it "should return new grandchild between right child and parent" do
      assert_equal binpos("0110011"), binpos("011001").between(binpos("01101"))
    end

    it "should return new parent between siblings" do
      assert_equal binpos("01101"), binpos("011001").between(binpos("011011"))
    end

    it "should return new ancestor between cousins" do
      assert_equal binpos("011"), binpos("010101").between(binpos("011011"))
    end

    it "should return new root between distant cousins" do
      assert_equal binpos("1"), binpos("001101").between(binpos("111011"))
    end

    it "should return new parent between child and ancestor" do
      assert_equal binpos("010111"), binpos("011").between(binpos("0101101"))
    end

    it "should return new child between parent and distant descendant" do
      assert_equal binpos("0110101"), binpos("01101").between(binpos("0110101111"))
    end

    it "should return new ancestor between child and distant ancestor" do
      assert_equal binpos("011001111"), binpos("01101").between(binpos("01100111011"))
    end

    it "should return new position between siblings" do
      a, c = binpos("01101"), binpos("01111")
      b = a.between(c)
      assert_equal binpos("0111"), [c, a, b].sort[1]
    end

    it "should create positions between existing positions in order" do
      n = 20
      numbers = (0..n).to_a.shuffle
      list = {}
      numbers.each do |i|
        below = list[list.keys.find_all { |k| k < i }.max] || Position::MIN
        above = list[list.keys.find_all { |k| k > i }.min] || Position::MAX
        list[i] = below.between(above)
      end
      assert_equal (0..n).to_a, list.sort_by { |k, pos| pos }.map(&:first)
    end
  end
end
