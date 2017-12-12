class CreateTodos < ActiveRecord::Migration[5.1]
  def change
    create_table :todos do |t|
      t.boolean :completed, default: false, null: false
      t.string :title

      t.timestamps
    end
  end
end
