module OrderedList
  module ActiveRecord
    module Balancing
      class PostgreSQLBalancer < AbstractBalancer
        def balancing_query
          update = [
            "UPDATE #{quoted_table_name}",
            "SET #{quoted_position_column} = CAST(#{quoted_rebuild_alias}.#{quoted_position_index} AS BIT(2))",
            "FROM (#{subquery}) #{quoted_rebuild_alias}",
            "WHERE #{quoted_table_name}.#{quoted_primary_key} = #{quoted_rebuild_alias}.#{quoted_primary_key}"
          ].join(" ")
        end
      end
    end
  end
end
