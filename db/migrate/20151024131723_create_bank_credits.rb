class CreateBankCredits < ActiveRecord::Migration
  def change
    create_table :bank_credits do |t|

      t.timestamps null: false
    end
  end
end
