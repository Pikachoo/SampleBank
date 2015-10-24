class AddBankCredit < ActiveRecord::Migration
  def change
    create_table :bank_credit do |t|
      t.integer :credit_type
      t.string :credit_type_another_home
      t.string :credit_type_another_car
      t.string :credit_type_another_card
      t.integer :granted_procedure
      t.integer :affirmation_of_commitments
      t.integer :collateral_customer
      t.integer :collateral_employee
      t.integer :score_existance
      t.integer :account_id
    end
  end
end
