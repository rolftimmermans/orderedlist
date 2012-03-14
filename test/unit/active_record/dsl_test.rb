require File.expand_path("../../../test_helper", __FILE__)

describe "dsl" do
  describe "act as" do
    it "should include module" do
      assert_kind_of OrderedList::ActiveRecord::Orderable, model.new
    end

    it "should set position column option" do
      klass = Class.new(ActiveRecord::Base) do
        acts_as_ordered_list column: "some_column"
      end
      assert_equal "some_column", klass.position_column
    end

    it "should set list scope" do
      klass = Class.new(ActiveRecord::Base) do
        acts_as_ordered_list scope: ["user_id", "active"]
      end
      assert_equal ["user_id", "active"], klass.list_scope_columns
    end

    it "should wrap list scope in array" do
      klass = Class.new(ActiveRecord::Base) do
        acts_as_ordered_list scope: :user_id
      end
      assert_equal [:user_id], klass.list_scope_columns
    end

    it "should complain when passing invalid options" do
      assert_raises ArgumentError do
        klass = Class.new(ActiveRecord::Base) do
          acts_as_ordered_list position: "foo"
        end
      end
    end
  end

  describe "scope columns" do
    it "should be inherited by child models" do
      parent = model do
        self.list_scope_columns = [:foo, :bar]
      end
      child = Class.new(parent)
      assert_equal [:foo, :bar], child.list_scope_columns
    end

    describe "when overridden" do
      before do
        @parent = model do
          self.list_scope_columns = [:foo, :bar]
        end
        @child = Class.new(@parent) do
          self.list_scope_columns = [:baz, :qux]
        end
      end

      it "should be updated in child" do
        assert_equal [:baz, :qux], @child.list_scope_columns
      end

      it "should not update parent scope" do
        assert_equal [:foo, :bar], @parent.list_scope_columns
      end
    end
  end
end
