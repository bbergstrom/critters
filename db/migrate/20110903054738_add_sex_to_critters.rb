class AddSexToCritters < ActiveRecord::Migration
  def self.up
    add_column :critters, :sex, :string
  end

  def self.down
    remove_column :critters, :sex
  end
end
