module OrderedList
  module ActiveRecord
    module Balancing
      class PostgreSQLBalancer < AbstractBalancer
        delegate :quoted_table_name, :quoted_primary_key, to: :relation

        def balancing_query
          update = [
            "UPDATE #{quoted_table_name}",
            "SET #{quoted_position_column} = #{balancing_calculation}",
            "FROM (#{position_index_query}) #{quoted_rebuild_alias}",
            "WHERE #{quoted_table_name}.#{quoted_primary_key} = #{quoted_rebuild_alias}.#{quoted_primary_key}"
          ].join(" ")
        end

        private

        def balancing_calculation
          # Casting makes this work for up to 9223372036854775807 records.
          bitstr = "#{quoted_rebuild_alias}.#{quoted_position_index}::int8 << (64 - #{quoted_rebuild_alias}.#{quoted_height}::int)"
          "substring(int8send(#{bitstr}) for ceil(#{quoted_rebuild_alias}.#{quoted_height} / 8))"
        end

        def position_index_query
          height = "floor(log(2, count(*) OVER ()) + 1) AS #{quoted_height}"
          position_index = "row_number() OVER (ORDER BY #{qualified_position_column}) AS #{quoted_position_index}"
          relation.reorder(nil).select([relation.table[relation.primary_key], height, position_index]).to_sql.strip
        end

        def qualified_position_column
          @qualified_position_column ||= connection.visitor.accept relation.table[relation.klass.position_column]
        end

        def quoted_height
          @quoted_height ||= connection.quote_column_name "height"
        end

        def quoted_position_index
          @quoted_position_index ||= connection.quote_column_name "position_index"
        end

        def quoted_rebuild_alias
          @quoted_rebuild_alias = connection.quote_table_name "rebuilt"
        end

        def quoted_position_column
          @quoted_position_column ||= connection.quote_column_name relation.klass.position_column
        end

      end
    end
  end
end
