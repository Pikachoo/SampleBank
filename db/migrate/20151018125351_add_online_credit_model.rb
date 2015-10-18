class AddOnlineCreditModel < ActiveRecord::Migration
  def change
    create_table :online_credit do |t|
      t.integer :creditProductType
      t.integer :currencyType
      t.integer :sumValue
      t.integer :termLoanProduct
      t.integer :provisionType
      t.text :otherProvisionType
      t.string :organizationName
      t.string :customersAddress
      t.integer :mainActivityType
      t.string :altMainActivity
      t.integer :organizationExperience
      t.string :customersFirstname
      t.string :customersLastname
      t.string :customersPatronymic
      t.string :customersPhone
      t.string :customersEmail
    end
  end

  def down
    remove_table :online_credit
  end
end
