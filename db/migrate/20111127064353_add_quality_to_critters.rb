class AddQualityToCritters < ActiveRecord::Migration
  def self.up
    add_column :critters, :quality, :integer
  end

  def self.down
    remove_column :critters, :quality
  end
end
