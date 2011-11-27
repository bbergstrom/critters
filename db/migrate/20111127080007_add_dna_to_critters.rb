class AddDnaToCritters < ActiveRecord::Migration
  def self.up
    add_column :critters, :dna, :text
  end

  def self.down
    remove_column :critters, :dna
  end
end
