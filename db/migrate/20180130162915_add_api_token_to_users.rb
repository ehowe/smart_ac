class AddAPITokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :api_key, :string, null: false, length: 32

    add_index :users, :api_key
  end
end
