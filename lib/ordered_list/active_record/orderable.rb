module OrderedList
  module ActiveRecord
    module Orderable
      # TODO: This should not be used with scoped lists, but it's very useful
      # for lists that span the entire table.
      def list
        ordered.extending(List, Balancing)
      end

      def ordered
        order(arel_table[position_column].asc)
      end

      def reversed
        ordered.reverse_order
      end
    end
  end
end
