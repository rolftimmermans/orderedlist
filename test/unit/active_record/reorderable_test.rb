require File.expand_path("../../../test_helper", __FILE__)

describe "reorderable" do
  describe "constructor" do
    it "should store string representation in position attribute" do
      assert_equal "101101", list_model.new(position: pos("101101")).read_attribute(:position)
    end
  end

  describe "position" do
    it "should return position object" do
      assert_equal pos("101101"), list_model.new(position: "101101").position
    end

    it "should return nil for missing position" do
      assert_equal nil, list_model.new.position
    end
  end

  describe "list" do
    it "should generate relation with bound variables" do
      list_model do
        self.list_scope_columns = [:active, :user_id]
      end
      assert_equal [[list_model.columns_hash["active"], true], [list_model.columns_hash["user_id"], 3]],
        list_model.new(active: true, user_id: 3).list.bind_values
    end

    it "should generate relation with scope conditions" do
      assert_equal list_model.list_scope_columns,
        list_model.new.list.where_values.map { |condition| condition.left.name.to_sym }
    end
  end
end
