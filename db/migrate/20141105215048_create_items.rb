class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.string :type

      t.timestamps null: false
    end
    add_index :items, [:type, :id]
  end
end
