class CreateLikes < ActiveRecord::Migration[8.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false
      t.references :post, null: false
      t.timestamps
    end
  end
end
