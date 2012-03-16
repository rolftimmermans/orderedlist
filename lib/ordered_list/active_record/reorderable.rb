module OrderedList
  module ActiveRecord
    module Reorderable
      extend ActiveSupport::Concern

      included do
        # If the position is still unset when creating a new record,
        # automatically add it to the list.
        before_create :add_to_list, unless: :position?
      end

      # Returns the position of this record within the list. The position is
      # represented as a path in a binary tree. The path is encoded as a bit
      # string. It can be compared with other positions, but cannot be
      # expressed as a number without knowing the total number of records in
      # the list.
      def position
        pos = read_attribute(position_column) and Position.parse(pos)
      end

      # Returns a relation that represents all items in the list this record
      # is bound to based on the scope columns.
      def list
        list_scope_columns.inject(self.class.list) do |relation, column|
          relation.send(:bound_equality, column.to_s, read_attribute(column))
        end
      end

      def append
        transaction do
          self.position = list.position_after_last
          save
        end
      end

      def prepend
        transaction do
          self.position = list.position_before_first
          save
        end
      end

      # Adds a new record to the list. This is called automatically when a
      # record is created. By default, new records are appended to the end of
      # the list. To change the strategy, override this method and add the
      # record in a different way.
      def add_to_list
        self.position = list.position_after_last
      end

      protected

      # Assign a new position. The position must be a bit array representing
      # a path in a binary tree. It may not be equal to any other position in
      # the same list scope.
      def position=(pos)
        write_attribute(position_column, pos.to_s)
      end
    end
  end
end
