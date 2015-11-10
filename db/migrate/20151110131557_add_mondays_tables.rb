class AddMondaysTables < ActiveRecord::Migration
  def change
    create_table "credit_payment_type", force: :cascade do |t|
      t.string  "name",       limit: 42,             null: false
    end

    create_table "credit_warranty_type", force: :cascade do |t|
      t.string  "name",       limit: 42,             null: false
    end

    create_table "client_job_type", force: :cascade do |t|
      t.string  "name",       limit: 42,             null: false
    end

    create_table "currency", force: :cascade do |t|
      t.string  "name",       limit: 42,             null: false
    end

    create_table "client_credit_goal", force: :cascade do |t|
      t.string  "name",       limit: 42,             null: false
    end
  end
end
