require File.expand_path("../../../test_helper", __FILE__)

describe "position boundary" do
  it "should respond to each" do
    assert Position.new.respond_to?(:each)
  end

  describe "to s" do
    it "should return partial encoded string" do
      assert_equal "1111...", Position::MAX.to_s
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
