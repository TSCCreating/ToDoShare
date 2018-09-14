class CreateTodos < ActiveRecord::Migration[5.2]
  def change
    create_table :todos do |t|
    t.string :first_body
    t.string :second_body
    t.string :third_body
    t.integer :user_id, foreign_key: true
    t.string :twitter_id, foreign_key: true
    t.integer :likes_count
    t.timestamps
    end
  end
end
