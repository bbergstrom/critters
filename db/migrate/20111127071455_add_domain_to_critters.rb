class AddDomainToCritters < ActiveRecord::Migration
  def self.up
    add_column :critters, :domain, :string
  end

  def self.down
    remove_column :critters, :domain
  end
end
