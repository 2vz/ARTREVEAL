class CreateWorkarts < ActiveRecord::Migration[7.1]
  def change
    create_table :workarts do |t|
      t.string :description_short
      t.string :description_middle
      t.string :description_long
      t.string :image_url

      t.timestamps
    end
  end
end
