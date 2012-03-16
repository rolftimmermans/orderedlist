# Fake connection class to avoid hitting a real database for our unit tests.
class ConnectionDouble < ActiveRecord::ConnectionAdapters::AbstractAdapter
  class Column < ActiveRecord::ConnectionAdapters::Column
  end

  # For tests.
  attr_reader :last_query, :last_binds

  # For AR/Arel.
  attr_reader :tables, :columns_hash

  def initialize(*)
    super(nil)
    @tables = %w(rows)
    @columns = {
      "rows" => [
        Column.new("id", nil, :integer),
        Column.new("position", nil, :text),
        Column.new("active", nil, :boolean),
        Column.new("user_id", nil, :integer),
        Column.new("some_column", nil, :text)
      ]
    }
    @columns_hash = {
      "rows" => Hash[@columns["rows"].map { |x| [x.name, x] }]
    }
    @visitor = Arel::Visitors::ToSql.new(self)
  end

  def adapter_name
    "PostgreSQL"
  end

  def columns(name, message = nil)
    @columns[name.to_s]
  end

  def select_all(arel, name = nil, binds = [])
    @last_query = arel
    @last_binds = Hash[binds.map { |k, v| [k.name, v] }]
    @returns || []
  end
  alias_method :update, :select_all

  def returning(*returns)
    @returns = returns
  end

  def quote_table_name(name)
    "\"#{name.to_s}\""
  end

  def quote_column_name(name)
    "\"#{name.to_s}\""
  end
end
