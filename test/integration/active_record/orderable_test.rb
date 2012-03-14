require File.expand_path("../../../test_helper", __FILE__)

describe "orderable" do
  before :each do
    DatabaseCleaner.clean
  end

  describe "position" do
    it "should return stored position" do
      item = Item.create(position: "101101")
      assert_equal Position.parse("101101"), item.reload.position
    end
  end

  describe "whith ordered scope" do
    it "should sort by position" do
      item2 = Item.create(position: "101101")
      item3 = Item.create(position: "11101")
      item1 = Item.create(position: "00111")
      assert_equal [item1, item2, item3], Item.ordered
    end
  end

  describe "creating first item" do
    it "should insert item at root" do
      assert_equal Position.parse("1"), Item.create.position
    end
  end

  describe "creating new item" do
    it "should insert item after last one" do
      item1 = Item.create(position: "11001")
      item2 = Item.create
      assert_equal [item1, item2], Item.ordered.to_a
    end
  end

  describe "append" do
    it "should save item" do
      Item.new.append
      assert_equal 1, Item.count
    end

    it "should add item after last one" do
      item1 = Item.create(position: "1")
      item2 = Item.new
      item2.append
      assert_equal [item1, item2], Item.ordered.to_a
    end

    it "should save existing item" do
      item = Item.create
      item.name = "foo"
      item.append
      assert_equal "foo", Item.first.name
    end

    it "should move existing item to last one" do
      item1 = Item.create
      item2 = Item.create(position: "001")
      item2.append
      assert_equal item2, Item.ordered.last
    end
  end

  describe "prepend" do
    it "should save item" do
      Item.new.prepend
      assert_equal 1, Item.count
    end

    it "should add item after last one" do
      item1 = Item.create(position: "1")
      item2 = Item.new
      item2.prepend
      assert_equal [item2, item1], Item.ordered.to_a
    end

    it "should save existing item" do
      item = Item.create
      item.name = "foo"
      item.prepend
      assert_equal "foo", Item.first.name
    end

    it "should move existing item to last one" do
      item1 = Item.create
      item2 = Item.create(position: "001")
      item2.prepend
      assert_equal item2, Item.reversed.last
    end
  end
end
