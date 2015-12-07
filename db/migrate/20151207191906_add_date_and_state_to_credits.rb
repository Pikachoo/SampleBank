class AddDateAndStateToCredits < ActiveRecord::Migration
  def change
    create_table :credit_states do |t|
      t.string :name
    end
  end
end
