require "bundler"

$adapter = ENV["DB"] || "pg"

# TODO: Use something like appraisal to test multiple dependency versions.
Bundler.require :default, :test, $adapter.to_sym

SimpleCov.start do
  add_filter File.expand_path("..", __FILE__)
  add_group "Position", "lib/ordered_list/position"
  add_group "Active Record", "lib/ordered_list/active_record"
end

Combustion.path = "test/dummy"
Combustion.initialize! :active_record

DatabaseCleaner.strategy = $adapter == "mysql" ? :truncation : :deletion

require "minitest/autorun"

require File.expand_path("../connection_double", __FILE__)

class MiniTest::Unit::TestCase
  class << self
    def db
      $adapter
    end
  end

  def binpos(bits)
    Position.new([bits].pack("B*"))
  end

  def hexpos(hex)
    Position.new([hex].pack("H*"))
  end
  
  def inline_sql(str)
    str.gsub(/^\s+/, "").gsub("\n", " ").strip
  end

  def sql(arel)
    if Array === arel
      arel.map { |a| sql(a) }.join
    else
      connection.visitor.accept(arel)
    end
  end

  def connection
    $connection = (@connection ||= ConnectionDouble.new)
  end

  def empty_model
    connection
    Class.new(ActiveRecord::Base) do
      class << self
        def connection
          $connection
        end
      end
      self.table_name = "rows"
      attr_protected
      instance_eval(&Proc.new) if block_given?
    end
  end

  def list_model
    @list_model ||= empty_model do
      acts_as_ordered_list
      instance_eval(&Proc.new) if block_given?
    end
  end
end

# Avoid typing the main gem namespace all the time.
include OrderedList
