class AddAddressToWorkarts < ActiveRecord::Migration[7.1]
  def change
    add_column :workarts, :address, :string
  end
end
