require "bundler"

Bundler.require :default, :test, :pg, :sqlite, :mysql

$adapter = ENV["DB"] || "pg"

Combustion.path = "test/dummy"
Combustion.initialize! :active_record

DatabaseCleaner.strategy = $adapter == "mysql" ? :truncation : :deletion

# TODO: Use something like appraisal to test multiple dependency versions.

require "minitest/autorun"

class ConnectionDouble < ActiveRecord::ConnectionAdapters::AbstractAdapter
  attr_reader :last_query, :last_binds

  def initialize(*)
    super(nil)
    @visitor = Arel::Visitors::PostgreSQL.new self
  end

  def select_all(arel, *, binds)
    @last_query = arel
    @last_binds = Hash[binds.map { |k, v| [k.name, v] }]
    @returns || []
  end

  def returning(*returns)
    @returns = returns
  end
end

class MiniTest::Unit::TestCase
  class << self
    def db
      $adapter
    end
  end

  def pos(s)
    Position.parse(s)
  end

  def connection
    $connection = (@connection ||= ConnectionDouble.new)
  end

  def model
    connection
    @model ||= Class.new(ActiveRecord::Base) do
      self.table_name = "rows"
      attr_accessible :id, :position

      acts_as_ordered_list

      class << self
        def connection
          $connection
        end
      end

      instance_eval(&Proc.new) if block_given?
    end
  end
end

include OrderedList
