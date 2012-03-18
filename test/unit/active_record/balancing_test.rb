require File.expand_path("../../../test_helper", __FILE__)

describe "balancing" do
  describe "balance" do
    # it "should issue rebuilding query" do
    #   list_model.list.balance!
    #   assert_equal %Q[(SELECT "rows"."id", ROW_NUMBER() OVER (ORDER BY "rows"."position") FROM "rows")],
    #     connection.last_query.to_sql
    # end
  end
end
