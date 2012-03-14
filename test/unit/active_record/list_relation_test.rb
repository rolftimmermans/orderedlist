require File.expand_path("../../../test_helper", __FILE__)

describe "list relation" do
  describe "ordered" do
    it "should sort by default position column" do
      assert_equal [%Q["rows"."position" ASC]],
        model.list_base.ordered.arel.orders.map(&:to_sql)
    end

    it "should sort by custom position column" do
      model do
        self.position_column = "special_pos"
      end
      assert_equal [%Q["rows"."special_pos" ASC]],
        model.list_base.ordered.arel.orders.map(&:to_sql)
    end
  end

  describe "reversed" do
    it "should reverse sort by default position column" do
      assert_equal [%Q["rows"."position" DESC]],
        model.list_base.reversed.arel.orders.map(&:to_sql)
    end

    it "should reverse sort by custom position column" do
      model do
        self.position_column = "special_pos"
      end
      assert_equal [%Q["rows"."special_pos" DESC]],
        model.list_base.reversed.arel.orders.map(&:to_sql)
    end
  end

  describe "before" do
    it "should select by positions before object" do
      connection.returning("position" => "1011")
      assert_equal %Q[WHERE ("rows"."position" < '1011')],
        model.list_base.before(model.new(id: 3)).arel.where_sql
    end

    it "should select by positions before id" do
      connection.returning("position" => "101")
      assert_equal %Q[WHERE ("rows"."position" < '101')],
        model.list_base.before(123).arel.where_sql
    end

    it "should select by positions before position" do
      assert_equal %Q[WHERE ("rows"."position" < '101101')],
        model.list_base.before(pos("101101")).arel.where_sql
    end
  end

  describe "after" do
    it "should select by positions after object" do
      connection.returning("position" => "1011")
      assert_equal %Q[WHERE ("rows"."position" > '1011')],
        model.list_base.after(model.new(id: 3)).arel.where_sql
    end

    it "should select by positions after id" do
      connection.returning("position" => "101")
      assert_equal %Q[WHERE ("rows"."position" > '101')],
        model.list_base.after(123).arel.where_sql
    end

    it "should select by positions after position" do
      assert_equal %Q[WHERE ("rows"."position" > '101101')],
        model.list_base.after(pos("101101")).arel.where_sql
    end
  end

  describe "position of" do
    it "should return position" do
      position = pos("1110101")
      assert_equal pos("1110101"), model.list_base.position_of(position)
    end

    it "should return position of given id" do
      connection.returning("position" => "10101")
      assert_equal pos("10101"), model.list_base.position_of(123)
    end

    it "should issue query for position of given id" do
      model.list_base.position_of(3)
      assert_equal 3, connection.last_binds["id"]
    end

    it "should return position of given object" do
      connection.returning("position" => "1011")
      assert_equal pos("1011"), model.list_base.position_of(model.new(id: 3))
    end

    it "should issue query for position of given object" do
      model.list_base.position_of(model.new(id: 3))
      assert_equal 3, connection.last_binds["id"]
    end

    it "should return nil if no results" do
      assert_equal nil, model.list_base.position_of(1234)
    end
  end
end
