class CreateTitles < ActiveRecord::Migration
  def change
    create_table :titles do |t|
      t.integer :user_id, :references => [:users, :id]
      t.string :title
    end
  end
end
