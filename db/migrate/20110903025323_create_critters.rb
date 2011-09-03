class CreateCritters < ActiveRecord::Migration
  def self.up
    create_table :critters do |t|
      t.string :name
      t.string :url
      t.integer :level
      t.integer :hp
      t.decimal :dodge
      t.decimal :crit
      t.integer :physical_damage
      t.integer :fire_damage
      t.integer :earth_damage
      t.integer :water_damage
      t.integer :air_damage
      t.integer :light_damage
      t.integer :dark_damage
      t.integer :absorb_fire
      t.integer :absorb_earth
      t.integer :absorb_water
      t.integer :absorb_air
      t.integer :absorb_light
      t.integer :absorb_dark
      t.boolean :fire
      t.boolean :earth
      t.boolean :water
      t.boolean :air
      t.boolean :light
      t.boolean :dark

      t.timestamps
    end
  end

  def self.down
    drop_table :critters
  end
end
