class AddCoordinatesToWorkarts < ActiveRecord::Migration[7.1]
  def change
    add_column :workarts, :latitude, :float
    add_column :workarts, :longitude, :float
  end
end
