require File.expand_path("../../../test_helper", __FILE__)

describe "rebuilding" do
  before :each do
    DatabaseCleaner.clean
  end

  # describe "rebuild" do
  #   it "should rebuild position for all records" do
  #     item1 = Item.create(position: "00111")
  #     item2 = Item.create(position: "101101")
  #     item3 = Item.create(position: "11101")
  #     Item.list.balance!
  #     assert_equal %w[01 1 11], Item.ordered.map(&:position).map(&:to_s)
  #   end
  # 
  #   it "should shift position forward for all records" do
  #     item1 = Item.create(position: "001")
  #     item2 = Item.create(position: "01")
  #     item3 = Item.create(position: "1")
  #     Item.list.balance!
  #     assert_equal %w[01 1 11], Item.ordered.map(&:position).map(&:to_s)
  #   end
  # 
  #   it "should shift position backward for all records" do
  #     item1 = Item.create(position: "1")
  #     item2 = Item.create(position: "11")
  #     item3 = Item.create(position: "111")
  #     Item.list.balance!
  #     assert_equal %w[01 1 11], Item.ordered.map(&:position).map(&:to_s)
  #   end
  # 
  #   it "should rebuild positions so duplicates cannot occur" do
  #     item1 = Item.create(position: "01")
  #     item2 = Item.create(position: "1")
  #     item3 = Item.create(position: "11")
  #     Item.list.balance!
  #     assert_raises ActiveRecord::RecordNotUnique do
  #       Item.create(position: "1")
  #     end
  #   end
  # end

  # it "bench" do
  #   n = 10
  #   20.times { Item.create }
  #   p Item.connection.select_all Item.list.reversed.send(:b).to_sql
  #   p Item.connection.select_all Item.list.reversed.send(:a).to_sql
  #   exit
  #   require "benchmark"
  #   Benchmark.bm do |bm|
  #     bm.report "stupid" do
  #       n.times {
  #         Item.list.send(:b).to_a
  #       }
  #     end
  #     bm.report "pg" do
  #       n.times {
  #         Item.list.send(:a).to_a
  #       }
  #     end
  #   end
  # end
end
