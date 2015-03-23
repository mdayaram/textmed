class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.boolean :received
      t.string :body

      t.timestamps null: false
    end
  end
end
