require File.expand_path("../../../test_helper", __FILE__)

describe "list" do
  describe "before" do
    it "should select by positions before object" do
      connection.returning("position" => "1011")
      assert_equal %Q[("rows"."position" < '1011')],
        sql(list_model.list.before(list_model.new(id: 3)).arel.constraints)
    end

    it "should select by positions before id" do
      connection.returning("position" => "101")
      assert_equal %Q[("rows"."position" < '101')],
        sql(list_model.list.before(123).arel.constraints)
    end

    it "should select by positions before position" do
      assert_equal %Q[("rows"."position" < '101101')],
        sql(list_model.list.before(pos("101101")).arel.constraints)
    end
  end

  describe "after" do
    it "should select by positions after object" do
      connection.returning("position" => "1011")
      assert_equal %Q[("rows"."position" > '1011')],
        sql(list_model.list.after(list_model.new(id: 3)).arel.constraints)
    end

    it "should select by positions after id" do
      connection.returning("position" => "101")
      assert_equal %Q[("rows"."position" > '101')],
        sql(list_model.list.after(123).arel.constraints)
    end

    it "should select by positions after position" do
      assert_equal %Q[("rows"."position" > '101101')],
        sql(list_model.list.after(pos("101101")).arel.constraints)
    end
  end

  describe "position of" do
    it "should return position" do
      position = pos("1110101")
      assert_equal pos("1110101"), list_model.list.position_of(position)
    end

    it "should return position of given id" do
      connection.returning("position" => "10101")
      assert_equal pos("10101"), list_model.list.position_of(123)
    end

    it "should issue query for position of given id" do
      list_model.list.position_of(3)
      assert_equal 3, connection.last_binds["id"]
    end

    it "should return position of given object" do
      connection.returning("position" => "1011")
      assert_equal pos("1011"), list_model.list.position_of(list_model.new(id: 3))
    end

    it "should issue query for position of given object" do
      list_model.list.position_of(list_model.new.tap { |o| o.id = 3 })
      assert_equal 3, connection.last_binds["id"]
    end

    it "should return nil if no results" do
      assert_equal nil, list_model.list.position_of(1234)
    end
  end
end
