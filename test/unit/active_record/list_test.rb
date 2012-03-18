require File.expand_path("../../../test_helper", __FILE__)

describe "list" do
  describe "before" do
    it "should select by positions before object" do
      connection.returning("position" => "\xf6")
      assert_equal %Q[("rows"."position" < '\xf6')],
        sql(list_model.list.before(list_model.new(id: 3)).arel.constraints)
    end

    it "should select by positions before id" do
      connection.returning("position" => "\x7a")
      assert_equal %Q[("rows"."position" < '\x7a')],
        sql(list_model.list.before(123).arel.constraints)
    end

    it "should select by positions before position" do
      assert_equal %Q[("rows"."position" < '\x7a')],
        sql(list_model.list.before(hexpos("7a")).arel.constraints)
    end
  end

  describe "after" do
    it "should select by positions after object" do
      connection.returning("position" => "\xf6")
      assert_equal %Q[("rows"."position" > '\xf6')],
        sql(list_model.list.after(list_model.new(id: 3)).arel.constraints)
    end

    it "should select by positions after id" do
      connection.returning("position" => "\x7a")
      assert_equal %Q[("rows"."position" > '\x7a')],
        sql(list_model.list.after(123).arel.constraints)
    end

    it "should select by positions after position" do
      assert_equal %Q[("rows"."position" > '\x7a')],
        sql(list_model.list.after(hexpos("7a")).arel.constraints)
    end
  end

  describe "position of" do
    it "should return position" do
      position = hexpos("f6")
      assert_equal hexpos("f6"), list_model.list.position_of(position)
    end

    it "should return position of given id" do
      connection.returning("position" => "\x7a")
      assert_equal hexpos("7a"), list_model.list.position_of(123)
    end

    it "should issue query for position of given id" do
      list_model.list.position_of(3)
      assert_equal 3, connection.last_binds["id"]
    end

    it "should return position of given object" do
      connection.returning("position" => "\x7a")
      assert_equal hexpos("7a"), list_model.list.position_of(list_model.new(id: 3))
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
