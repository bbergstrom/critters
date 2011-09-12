class AddAbilityBools2ToCritters < ActiveRecord::Migration
  def self.up
    add_column :critters, :has_crit, :boolean
    add_column :critters, :has_dodge, :boolean
  end

  def self.down
    remove_column :critters, :has_dodge
    remove_column :critters, :has_crit
  end
end
