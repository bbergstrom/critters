class AddBredBooleanToCritter < ActiveRecord::Migration
  def self.up
    add_column :critters, :bred, :boolean
  end

  def self.down
    remove_column :critters, :bred
  end
end
