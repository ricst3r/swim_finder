class AddAddressToLocation < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :address, :string
  end
end
