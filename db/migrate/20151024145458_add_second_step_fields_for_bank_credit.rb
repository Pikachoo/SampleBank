class AddSecondStepFieldsForBankCredit < ActiveRecord::Migration
  def change
    change_table :bank_credits do |t|
      t.integer :credit_sum
      t.integer :credit_term
      t.integer :credit_limit_term
      t.integer :total_income
      t.integer :make_insurance
      t.integer :repayment_method
    end
  end
end
