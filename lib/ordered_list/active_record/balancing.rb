require "ordered_list/active_record/balancing/abstract_balancer"
require "ordered_list/active_record/balancing/postgresql_balancer"

module OrderedList
  module ActiveRecord
    module Balancing
      def balance!
        balancing_adapter.new(self).balance
      end

      private

      def balancing_adapter
        case connection.adapter_name.downcase
        when "postgresql"
          PostgreSQLBalancer
        when "mysql", "mysql2"
          MySQLBalancer
        when "sqlite3"
          SQLiteBalancer
        when "sqlserver"
          SQLServerBalancer
        else
          raise NotImplementedError, "Balancing is not implemented for #{connection.adapter_name}"
        end
      end
    end
  end
end

#
#       include Arel::Nodes
#
#       def balance!
#         subquery = select(table[primary_key]).select_position_index.to_sql.strip
# # p        connection.select_all subquery
#         # connection.execute "SET @row_number := NULL"
#         # p connection.select_all "SELECT `items`.`id`, @row_number := @row_number + 1 `position_index` FROM `items`, (SELECT @row_number := 0) x"
#         # p connection.select_all "SELECT `items`.`id`, @row_number := @row_number + 1 `position_index` FROM `items`, (SELECT @row_number := 0) _init"
#         # exit
#         # p connection.select_all "SELECT `items`.`id`, @row_number := @row_number + 1 `position_index` FROM `items` HAVING NOT @row_number := 0"
#         # PostgreSQL:
#         # connection.execute "update pg_index set indimmediate  = false where indexrelid = 'index_items_on_position'::regclass"
#
#         update = %Q[
#           UPDATE #{quoted_table_name}
#           SET #{quoted_position_column} = CAST(#{quoted_rebuild_alias}.#{quoted_position_index} AS BIT(2))
#           FROM (#{subquery}) #{quoted_rebuild_alias}
#           WHERE #{quoted_table_name}.#{quoted_primary_key} = #{quoted_rebuild_alias}.#{quoted_primary_key}
#         ]
#
#         # MySQL:
#         update = %Q[
#           UPDATE (SELECT @row_number := 0) _init, #{quoted_table_name}, (#{subquery}) #{quoted_rebuild_alias}
#           SET #{quoted_position_column} = LPAD(BIN(#{quoted_rebuild_alias}.#{quoted_position_index}), 2, '0')
#           WHERE #{quoted_table_name}.#{quoted_primary_key} = #{quoted_rebuild_alias}.#{quoted_primary_key}
#         ]
#
#         # MSSQL:
#         # http://www.codeproject.com/Articles/210406/INT-to-BINARY-string-in-SQL-Server
#         update = %Q[
#           UPDATE #{quoted_table_name}
#           SET #{quoted_position_column} = CAST(#{quoted_rebuild_alias}.#{quoted_position_index} AS BIT(2))
#           FROM (#{subquery}) #{quoted_rebuild_alias}
#           WHERE #{quoted_table_name}.#{quoted_primary_key} = #{quoted_rebuild_alias}.#{quoted_primary_key}
#         ]
#
#         connection.update update, "SQL"
#       end
#
#       protected
#
#       def select_position_index
#
#         #             user     system      total        real
#         # stupid  9.770000   0.040000   9.810000 (344.569327)
#         # pg      9.770000   0.040000   9.810000 ( 10.353377)
#
#         # MSSQL
#         select("row_number() OVER (ORDER BY #{qualified_position_column}) AS #{quoted_position_index}")
#
#         # MySQl
#         select("@row_number := @row_number + 1 #{quoted_position_index}")
#
#         # Any other database (SLOW, SLOW!)
#         select("(SELECT COUNT(*) + 1 FROM #{quoted_table_name} counting WHERE counting.#{quoted_position_column} < #{qualified_position_column}) AS #{quoted_position_index}")
#
#         # PostgreSQL
#         select("row_number() OVER (ORDER BY #{qualified_position_column}) AS #{quoted_position_index}")
#       end
#
#       def a
#         select("row_number() OVER (ORDER BY #{qualified_position_column}) AS #{quoted_position_index}")
#       end
#
#       def b
#         select("(SELECT COUNT(*) + 1 FROM #{quoted_table_name} counting WHERE counting.#{quoted_position_column} < #{qualified_position_column}) AS #{quoted_position_index}")
#       end
#
#       private
#
#       def quoted_position_index
#         @quoted_position_index ||= connection.quote_column_name "position_index"
#       end
#
#       def quoted_rebuild_alias
#         @quoted_rebuild_alias = connection.quote_table_name "rebuilt"
#       end
#
#       def quoted_position_column
#         @quoted_position_column ||= connection.quote_column_name klass.position_column
#       end
#
#       def qualified_position_column
#         @qualified_position_column ||= connection.visitor.accept table[klass.position_column]
#       end
#     end
#   end
# end
