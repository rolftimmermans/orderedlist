require File.expand_path("../../../test_helper", __FILE__)

describe "orderable" do
  describe "list" do
    it "should include list module" do
      assert_kind_of OrderedList::ActiveRecord::List, list_model.list
    end

    it "should include balancing module" do
      assert_kind_of OrderedList::ActiveRecord::Balancing, list_model.list
    end
  end

  describe "ordered" do
    it "should sort by default position column" do
      assert_equal %Q["rows"."position" ASC],
        sql(list_model.ordered.arel.orders)
    end

    it "should sort by custom position column" do
      list_model do
        self.position_column = "special_pos"
      end
      assert_equal %Q["rows"."special_pos" ASC],
        sql(list_model.ordered.arel.orders)
    end
  end

  describe "reversed" do
    it "should reverse sort by default position column" do
      assert_equal %Q["rows"."position" DESC],
        sql(list_model.reversed.arel.orders)
    end

    it "should reverse sort by custom position column" do
      list_model do
        self.position_column = "special_pos"
      end
      assert_equal %Q["rows"."special_pos" DESC],
        sql(list_model.reversed.arel.orders)
    end
  end
end
