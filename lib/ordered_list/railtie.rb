module OrderedList
  class Railtie < Rails::Railtie
    initializer "orderedlist" do
      ActiveSupport.on_load(:active_record) do
        require "ordered_list/active_record"
        require "ordered_list/position"
        OrderedList::ActiveRecord.initialize!
      end
    end
  end
end
