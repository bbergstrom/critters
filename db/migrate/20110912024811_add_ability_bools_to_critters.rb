class AddAbilityBoolsToCritters < ActiveRecord::Migration
  def self.up
    add_column :critters, :has_fire_damage, :boolean
    add_column :critters, :has_earth_damage, :boolean
    add_column :critters, :has_water_damage, :boolean
    add_column :critters, :has_air_damage, :boolean
    add_column :critters, :has_light_damage, :boolean
    add_column :critters, :has_dark_damage, :boolean
    add_column :critters, :has_absorb_fire, :boolean
    add_column :critters, :has_absorb_earth, :boolean
    add_column :critters, :has_absorb_water, :boolean
    add_column :critters, :has_absorb_air, :boolean
    add_column :critters, :has_absorb_light, :boolean
    add_column :critters, :has_absorb_dark, :boolean
  end

  def self.down
    remove_column :critters, :has_absorb_dark
    remove_column :critters, :has_absorb_light
    remove_column :critters, :has_absorb_air
    remove_column :critters, :has_absorb_water
    remove_column :critters, :has_absorb_earth
    remove_column :critters, :has_absorb_fire
    remove_column :critters, :has_dark_damage
    remove_column :critters, :has_light_damage
    remove_column :critters, :has_air_damage
    remove_column :critters, :has_water_damage
    remove_column :critters, :has_earth_damage
    remove_column :critters, :has_fire_damage
  end
end
