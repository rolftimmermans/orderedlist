module OrderedList
  module ActiveRecord
    module List
      # Returns all records before the given position, record or id.
      def before(record_or_position)
        where(table[klass.position_column].lt(position_of(record_or_position).to_s))
      end

      # Returns all records after the given position, record or id.
      def after(record_or_position)
        where(table[klass.position_column].gt(position_of(record_or_position).to_s))
      end

      # Returns the position of the given record or id.
      def position_of(id)
        # TODO: Not sure if position_of() should accept Positions.
        return id if Position === id

        # Get primary key (id) of given record, if the argument is a record.
        id = id.id if ::ActiveRecord::Base === id

        # We anticipate this query is going to used a lot, so we should
        # benefit from prepared statements. Make sure we use variable binding.
        bound_equality(primary_key, id).retrieve_position
      end

      # Returns a new position before the first item in the list given the
      # current scope.
      def position_before_first
        position_of_first.between(Position::MIN)
      end

      # Returns a new position after the last item in the list given the
      # current scope.
      def position_after_last
        position_of_last.between(Position::MAX)
      end

      # Returns a new position before the given record or id. The new position
      # is calculated to be directly before the given record, but directly
      # after the previous record.
      def position_before(id)
        reference = position_of(id)
        before(reference).position_of_last.between(reference)
      end

      # Returns a new position after the given record or id. The new position
      # is calculated to be directly after the given record, but directly
      # before the next record.
      def position_after(id)
        reference = position_of(id)
        after(reference).position_of_first.between(reference)
      end

      protected

      # Add equality predicates with variable binding so we can make use of
      # prepared statements.
      def bound_equality(column, value)
        substitute = connection.substitute_at(column, bind_values.length)
        where(table[column].eq(substitute)).bind([columns_hash[column], value])
      end

      # Returns the (first) position in the current scope.
      def retrieve_position
        scope = select(table[klass.position_column]).limit(1)
        result = connection.select_all(scope.arel, "SQL", scope.bind_values).first
        Position.parse(type_cast_attribute(result.keys.first, result)) if result
      end

      # Returns first position of all records in the current scope.
      def position_of_first
        ordered.retrieve_position || Position::MAX
      end

      # Returns last position of all records in the current scope.
      def position_of_last
        reversed.retrieve_position || Position::MIN
      end
    end
  end
end
