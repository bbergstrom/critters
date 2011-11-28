class AddParentKeysToCritter < ActiveRecord::Migration
  def self.up
    add_column :critters, :mother_id, :integer
    add_column :critters, :father_id, :integer
  end

  def self.down
    remove_column :critters, :father_id
    remove_column :critters, :mother_id
  end
end
