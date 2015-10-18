class CreateOnlineCredits < ActiveRecord::Migration
  def change
    create_table :online_credits do |t|

      t.timestamps null: false
    end
  end
end
