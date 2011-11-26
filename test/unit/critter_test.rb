require 'test_helper'

class CritterTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: critters
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  url              :string(255)
#  level            :integer
#  hp               :integer
#  dodge            :integer
#  crit             :integer
#  physical_damage  :integer
#  fire_damage      :integer
#  earth_damage     :integer
#  water_damage     :integer
#  air_damage       :integer
#  light_damage     :integer
#  dark_damage      :integer
#  absorb_fire      :integer
#  absorb_earth     :integer
#  absorb_water     :integer
#  absorb_air       :integer
#  absorb_light     :integer
#  absorb_dark      :integer
#  created_at       :datetime
#  updated_at       :datetime
#  user_id          :integer
#  sex              :string(255)
#  has_fire_damage  :boolean
#  has_earth_damage :boolean
#  has_water_damage :boolean
#  has_air_damage   :boolean
#  has_light_damage :boolean
#  has_dark_damage  :boolean
#  has_absorb_fire  :boolean
#  has_absorb_earth :boolean
#  has_absorb_water :boolean
#  has_absorb_air   :boolean
#  has_absorb_light :boolean
#  has_absorb_dark  :boolean
#  has_crit         :boolean
#  has_dodge        :boolean
#

