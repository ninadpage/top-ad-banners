class CreateConversions < ActiveRecord::Migration[5.0]
  def change
    create_table :conversions do |t|
      t.references :click, foreign_key: true
      t.float :revenue

      t.timestamps
    end
  end
end
