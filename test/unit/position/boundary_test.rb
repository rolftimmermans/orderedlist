require File.expand_path("../../../test_helper", __FILE__)

describe "position boundary" do
  it "should respond to each" do
    assert Position::MAX.respond_to?(:each)
  end

  describe "to s" do
    it "should return partial string for min" do
      assert_equal "0000...", Position::MIN.to_s
    end

    it "should return partial string for max" do
      assert_equal "ffff...", Position::MAX.to_s
    end
  end

  describe "length" do
    it "should be infinite" do
      assert 1.0/0, Position::MAX.length
    end
  end

  describe "when iterating" do
    it "should yield zero for minimum position" do
      enum = Position::MIN.to_enum
      5.times { enum.next }
      assert 0, enum.next
    end

    it "should yield one for maximum position" do
      enum = Position::MAX.to_enum
      5.times { enum.next }
      assert 1, enum.next
    end
  end

  # TODO: Fix the following pathological infinite loop:
  #   Position::MAX.between(Position::MAX)
end
