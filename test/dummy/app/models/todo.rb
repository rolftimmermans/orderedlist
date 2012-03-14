class Todo < ActiveRecord::Base
  acts_as_ordered_list scope: [:active, :user_id]

  belongs_to :user
end
