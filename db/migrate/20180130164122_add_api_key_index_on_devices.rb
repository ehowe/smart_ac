class AddAPIKeyIndexOnDevices < ActiveRecord::Migration[5.1]
  def change
    add_index :devices, :api_key
  end
end
