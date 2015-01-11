class CreateSearchTable < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.integer :user_id, :references => [:users, :id]
      t.string :search_term
    end
  end
end
