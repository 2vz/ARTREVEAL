class AddPrimaryArtistAndWorkartTitleToWorkarts < ActiveRecord::Migration[7.1]
  def change
    add_column :workarts, :primary_artist, :string
    add_column :workarts, :workart_title, :string
  end
end
