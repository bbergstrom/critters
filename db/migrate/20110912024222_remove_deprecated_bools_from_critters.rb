class RemoveDeprecatedBoolsFromCritters < ActiveRecord::Migration
  def self.up
    remove_column :critters, :fire
    remove_column :critters, :earth
    remove_column :critters, :water
    remove_column :critters, :air
    remove_column :critters, :light
    remove_column :critters, :dark
  end

  def self.down
    add_column :critters, :dark, :boolean
    add_column :critters, :light, :boolean
    add_column :critters, :air, :boolean
    add_column :critters, :water, :boolean
    add_column :critters, :earth, :boolean
    add_column :critters, :fire, :boolean
  end
end
