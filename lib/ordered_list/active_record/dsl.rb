module OrderedList
  module ActiveRecord
    # The DSL really only provides one method.
    module DSL
      def acts_as_ordered_list(options = {})
        options.assert_valid_keys(:column, :scope)
        self.position_column = options[:column] if options[:column]
        self.list_scope_columns = Array.wrap(options[:scope]) if options[:scope]
        include Orderable
      end
    end
  end
end
