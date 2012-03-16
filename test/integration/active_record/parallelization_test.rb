require File.expand_path("../../../test_helper", __FILE__)

describe "parallelized" do
  # TODO: The following tests are not deterministic. Can we use fibers and
  # callbacks in the Item model to simulate race conditions without causing
  # any deadlocks?

  def parallel(enum)
    items = []
    threads = enum.collect do
      Thread.new do
        begin
          items << yield
        ensure
          ActiveRecord::Base.connection.close
        end
      end
    end
    threads.each(&:join)
    items
  end

  # Sqlite uses giant locks on the database, and accessing the same database
  # from the same process just causes errors.
  if db != "sqlite"
    describe "creates" do
      it "should avoid race conditions" do
        n = 5
        items = parallel(n.times) do
          begin
            Item.create
          rescue ::ActiveRecord::RecordNotUnique
            retry
          end
        end
        assert_equal n, items.group_by { |i| i.position.to_s }.length
      end
    end

    describe "appends" do
      it "should avoid race conditions" do
        n = 20
        root = Item.create
        items = parallel(n.times) do
          begin
            Item.new.tap(&:append)
          rescue ::ActiveRecord::RecordNotUnique
            retry
          end
        end
        assert_equal n, items.group_by { |i| i.position.to_s }.length
      end
    end

    # TODO: Test necessity of a transaction in append/prepend.

      # it "should create items in order" do
        # n = 20
        # items = parallel((0..n).to_a.shuffle) do
        #   begin
        #     Item.create(name: i)
        #   rescue ::ActiveRecord::RecordNotUnique
        #     retry
        #   end
        # end
        # assert_equal (0..n).to_a, Item.ordered.map(&:name)
      # end
  end
end
