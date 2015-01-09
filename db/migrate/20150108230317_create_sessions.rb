class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.integer :user_id, :references => [:users, :id]
      t.string :token
    end
  add_index :sessions, :token, :unique => true
  end
end
