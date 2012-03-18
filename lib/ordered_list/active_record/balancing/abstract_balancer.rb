module OrderedList
  module ActiveRecord
    module Balancing
      class AbstractBalancer
        attr_reader :relation

        delegate :connection, to: :relation

        def initialize(relation)
          @relation = relation
        end

        def balance
          connection.update(balancing_query, "Balance")
        end

        private

        def balancing_query
          raise NotImplementedError
        end
      end
    end
  end
end
