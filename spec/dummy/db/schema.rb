ActiveRecord::Schema.define do
  self.verbose = false

  create_table "rooms" do |t|
    t.string  "name"
    t.string  "number"
    t.integer "capacity", null: false
  end

  create_table "users" do |t|
    t.string  "email"
    t.string  "name"
  end
end