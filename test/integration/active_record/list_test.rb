require File.expand_path("../../../test_helper", __FILE__)

describe "list" do
  before :each do
    DatabaseCleaner.clean
  end

  describe "position of" do
    before do
      @item1 = Item.create(position: "00111")
      @item2 = Item.create(position: "101101")
    end

    it "should return position of given object" do
      assert_equal @item2.position, Item.list.position_of(@item2)
    end

    it "should return position of given id" do
      assert_equal @item2.position, Item.list.position_of(@item2.id)
    end

    it "should return nil if given id does not exist" do
      assert_equal nil, Item.list.position_of(12345)
    end
  end

  it "should return last position of list" do
    item1 = Item.create(position: "00111")
    item2 = Item.create(position: "101101")
    item3 = Item.create(position: "11101")
    assert_equal "11101", Item.list.send(:position_of_last).to_s
  end

  it "should return first position of list" do
    item1 = Item.create(position: "00111")
    item2 = Item.create(position: "101101")
    item3 = Item.create(position: "11101")
    assert_equal "00111", Item.list.send(:position_of_first).to_s
  end

  it "should return nil as last position of empty list" do
    assert_equal Position::MIN, Item.list.send(:position_of_last)
  end

  it "should return nil as first position of empty list" do
    assert_equal Position::MAX, Item.list.send(:position_of_first)
  end

  it "should return new position between item and next item" do
    item1 = Item.create(position: "00111")
    item2 = Item.create(position: "101101")
    item3 = Item.create(position: "11101")
    pos = Item.list.position_after(item1)
    assert_equal [true, true], [item1.position < pos, pos < item2.position]
  end

  it "should return new position between item and previous item" do
    item1 = Item.create(position: "00111")
    item2 = Item.create(position: "101101")
    item3 = Item.create(position: "11101")
    pos = Item.list.position_before(item3)
    assert_equal [true, true], [item2.position < pos, pos < item3.position]
  end

  it "should return new position between item and max position" do
    item1 = Item.create(position: "00111")
    item2 = Item.create(position: "101101")
    item3 = Item.create(position: "11101")
    pos = Item.list.position_after(item3)
    assert item3.position < pos
  end

  it "should return new position between item and min position" do
    item1 = Item.create(position: "00111")
    item2 = Item.create(position: "101101")
    item3 = Item.create(position: "11101")
    pos = Item.list.position_before(item1)
    assert pos < item1.position
  end

  it "should return new position after last" do
    item1 = Item.create(position: "00111")
    item2 = Item.create(position: "101101")
    item3 = Item.create(position: "11101")
    pos = Item.list.position_after_last
    assert item3.position < pos
  end

  it "should return new position before first" do
    item1 = Item.create(position: "00111")
    item2 = Item.create(position: "101101")
    item3 = Item.create(position: "11101")
    pos = Item.list.position_before_first
    assert pos < item1.position
  end

  it "should return all items before given position" do
    item3 = Item.create(position: "11101")
    item1 = Item.create(position: "00111")
    item2 = Item.create(position: "101101")
    assert_equal [item1, item2], Item.list.before(item3.position)
  end

  it "should return all items before given object" do
    item3 = Item.create(position: "11101")
    item1 = Item.create(position: "00111")
    item2 = Item.create(position: "101101")
    assert_equal [item1, item2], Item.list.before(item3)
  end

  it "should return all items after given position" do
    item3 = Item.create(position: "11101")
    item1 = Item.create(position: "00111")
    item2 = Item.create(position: "101101")
    assert_equal [item3], Item.list.after(item2.position)
  end

  it "should return all items after given object" do
    item3 = Item.create(position: "11101")
    item1 = Item.create(position: "00111")
    item2 = Item.create(position: "101101")
    assert_equal [item3], Item.list.after(item2)
  end
end
