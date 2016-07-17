class CreateImpressions < ActiveRecord::Migration[5.0]
  def change
    create_table :impressions do |t|
      t.integer :banner_id
      t.integer :campaign_id

      t.timestamps
    end
  end
end
