class CreateUserWorkarts < ActiveRecord::Migration[7.1]
  def change
    create_table :user_workarts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :workart, null: false, foreign_key: true
      t.boolean :liked

      t.timestamps
    end
  end
end
