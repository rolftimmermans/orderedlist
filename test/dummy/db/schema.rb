ActiveRecord::Schema.define do
  create_table "items", force: true do |t|
    t.string :name
    t.string :position
  end
  # execute "ALTER TABLE items ADD COLUMN position BIT VARYING"
  add_index :items, :position, unique: true

  create_table "todos", force: true do |t|
    t.references :user
    t.boolean :active, default: true
    t.string :description
    t.string :position
  end
  # execute "ALTER TABLE items ADD COLUMN position BIT VARYING"
  add_index :todos, [:user_id, :active, :position], unique: true

  create_table "users", force: true do |t|
    t.string :name
  end

  create_table "rows", force: true do |t|
    t.string :position
  end
end
