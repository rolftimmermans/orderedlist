require File.expand_path("../../../test_helper", __FILE__)

describe "multiple lists" do
  before :each do
    DatabaseCleaner.clean
  end

  describe "creating first items in different lists" do
    it "should insert item at root" do
      2.times { User.create.todos.create }
      assert_equal [binpos("1")] * 2, Todo.all.map(&:position)
    end
  end

  describe "creating new items in different lists" do
    it "should insert item after last one" do
      user1 = User.create
      user2 = User.create
              user1.todos.create(position: binpos("1101"))
      todo1 = user2.todos.create(position: binpos("1101"))
      todo2 = user2.todos.create
      assert_equal [todo1, todo2], user2.todos.ordered
    end
  end

  # TODO: Add similar tests, but for scoped lists.

  # describe "append" do
  #   it "should save item" do
  #     Item.new.append
  #     assert_equal 1, Item.count
  #   end
  #
  #   it "should add item after last one" do
  #     item1 = Item.create(position: binpos("1"))
  #     item2 = Item.new
  #     item2.append
  #     assert_equal [item1, item2], Item.ordered.to_a
  #   end
  #
  #   it "should save existing item" do
  #     item = Item.create
  #     item.name = "foo"
  #     item.append
  #     assert_equal "foo", Item.first.name
  #   end
  #
  #   it "should move existing item to last one" do
  #     item1 = Item.create
  #     item2 = Item.create(position: binpos("001"))
  #     item2.append
  #     assert_equal item2, Item.ordered.last
  #   end
  # end
  #
  # describe "prepend" do
  #   it "should save item" do
  #     Item.new.prepend
  #     assert_equal 1, Item.count
  #   end
  #
  #   it "should add item after last one" do
  #     item1 = Item.create(position: binpos("1"))
  #     item2 = Item.new
  #     item2.prepend
  #     assert_equal [item2, item1], Item.ordered.to_a
  #   end
  #
  #   it "should save existing item" do
  #     item = Item.create
  #     item.name = "foo"
  #     item.prepend
  #     assert_equal "foo", Item.first.name
  #   end
  #
  #   it "should move existing item to last one" do
  #     item1 = Item.create
  #     item2 = Item.create(position: binpos("001"))
  #     item2.prepend
  #     assert_equal item2, Item.reversed.last
  #   end
  # end
end
