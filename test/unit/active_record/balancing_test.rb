require File.expand_path("../../../test_helper", __FILE__)

describe "balancing" do
  describe "balance" do
    it "should issue rebuilding query" do
      list_model.list.balance!
      assert_equal inline_sql(<<-SQL), connection.last_query
        UPDATE "rows"
        SET "position" = substring(int8send("rebuilt"."position_index"::int8 << (64 - "rebuilt"."height"::int)) for ceil("rebuilt"."height" / 8))
        FROM (SELECT "rows"."id", floor(log(2, count(*) OVER ()) + 1) AS "height", row_number() OVER (ORDER BY "rows"."position") AS "position_index" FROM "rows") "rebuilt"
        WHERE "rows"."id" = "rebuilt"."id"
      SQL
    end
  end
end
