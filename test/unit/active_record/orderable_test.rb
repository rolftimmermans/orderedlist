require File.expand_path("../../../test_helper", __FILE__)

describe "orderable" do
  describe "constructor" do
    it "should store string representation in position attribute" do
      assert_equal "101101", model.new(position: pos("101101")).read_attribute(:position)
    end
  end

  describe "position" do
    it "should return position object" do
      assert_equal pos("101101"), model.new(position: "101101").position
    end

    it "should return nil for missing position" do
      assert_equal nil, model.new.position
    end
  end

  describe "list" do
    it "should generate relation with bound variables" do
      model do
        self.list_scope_columns = [:active, :user_id]
      end
      assert_equal %Q[WHERE "rows"."active" = ? AND "rows"."user_id" = ?], model.new.list.where_sql
    end

    it "should generate relation with scope conditions" do
      assert_equal model.list_scope_columns,
        model.new.list.where_values.map { |condition| condition.left.name.to_sym }
    end
  end
end
