class AddUserRefToCritters < ActiveRecord::Migration
  def self.up
    add_column :critters, :user_id, :integer
  end

  def self.down
    remove_column :critters, :user_id
  end
end
