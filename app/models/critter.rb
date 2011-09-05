require 'uri'
require 'curb'

class Critter < ActiveRecord::Base
  belongs_to :user
  #attr_accessible :name, :url
  validates :name, :presence => true
  validates :url, :presence => true,
                  :format => { :with => URI::regexp(%w(http https)) }
  validates :user_id, :presence => true
  before_create :birth

  BASE_STATS = {
    :level => 1,
    :hp => 10,
    :dodge => 0.05,
    :crit => 0.05,
    :physical_damage => 2,
    :fire_damage => 1,
    :earth_damage => 1,
    :water_damage => 1,
    :air_damage => 1,
    :light_damage => 1,
    :dark_damage => 1,
    :absorb_fire => 1,
    :absorb_earth => 1,
    :absorb_water => 1,
    :absorb_air => 1,
    :absorb_light => 1,
    :absorb_dark => 1,
    :fire => false,
    :earth => false,
    :water => false,
    :air => false,
    :light => false,
    :dark => false
  }
  LETTERS = ("a".."z")
  NUMBERS = (0..9)
  ALLELE_PAIRS = %w{ DD DR RD RR }
  # Genetics definition, by chromosome, allele, then trait symbol.
  GENETICS = {
    'e' => {
      :d => { :absorb_fire => :add_one_per_level }
    },
    't' => {
      :r => { :dodge => :add_one }
    },
    'a' => {
      :d => { :absorb_earth => :add_one_per_level }
    },
    'o' => {
      :d => { :absorb_air => :add_one_per_level }
    },
    'i' => {
      :d => { :absorb_water => :add_one_per_level }
    },
    'n' => {
      :d => { :hp => :add_10_per_level }
    },
    's' => {
      :d => { :earth_damage => :double }
    },
    'r' => {
      :d => { :water_damage => :add_one_per_level }
    },
    'h' => {
      :d => { :fire_damage => :double }
    },
    'l' => {
      :d => { :air_damage => :unable }
    },
    'd' => {
      :d => { :earth_damage => :add_one_per_level }
    },
    'c' => {
      :r => { :crit => :add_one }
    },
    'u' => {
      :d => { :fire_damage => :unable }
    },
    'm' => {
      :d => { :absorb_fire => :unable }
    },
    'f' => {
      :d => { :fire_damage => :add_one_per_level }
    },
    'p' => {
      :d => { :physical_damage => :double }
    },
    'g' => {
      :d => { :earth_damage => :unable }
    },
    'w' => {
      :d => { :air_damage => :double }
    },
    'y' => {
      :d => { :water_damage => :double }
    },
    'b' => {
      :d => { :air_damage => :add_one_per_level }
    },
    'v' => {
      :d => { :crit => :unable }
    },
    'k' => {
      :d => { :absorb_earth => :unable }
    },
    'x' => {
      :d => { :dodge => :unable }
    },
    'j' => {
      :d => { :water_damage => :unable }
    },
    'q' => {
      :d => { :absorb_air => :unable }
    },
    'z' => {
      :d => { :absorb_water => :unable }
    },
    0 => {
      :d => { :light_damage => :add_one_per_level }
    },
    1 => {
      :d => { :light_damage => :unable }
    },
    2 => {
      :d => { :absorb_light => :unable }
    },
    3 => {
      :d => { :light_damage => :double }
    },
    4 => {
      :d => { :absorb_light => :add_one_per_level }
    },
    5 => {
      :d => { :dark_damage => :add_one_per_level }
    },
    6 => {
      :d => { :dark_damage => :unable }
    },
    7 => {
      :d => { :absorb_dark => :unable }
    },
    8 => {
      :d => { :dark_damage => :double }
    },
    9 => {
      :d => { :absorb_dark => :add_one_per_level }
    }
  }

  def url_status
    c = Curl::Easy.http_head url
    c.perform
    logger.debug "url_status for #{url} is #{c.response_code}"
    return (c.response_code == 200)
  end

  def parse_dna(url)
    result = {}
    LETTERS.each do |l|
      i = url.index(l)
      if url.include?(l) && !i.nil? && i < 18
        r = rand(4)
        result[l] = ALLELE_PAIRS[r]
      end
    end
    NUMBERS.each do |n|
      i = url.index(n)
      if url.include?(n) && !i.nil? && i < 18
        r = rand(4)
        result[n] = ALLELE_PAIRS[n]
      end
    end
    return result
  end

  # Run through DNA and apply symbol traits.
  # Supported traits :add_one_per_level, :add_10_per_level, :double, :unable
  def build_stats(dna)
    # TODO: write rules around genetic traits
    # TODO: change mass assignment so attr_accessible security can be turned back on
    self.attributes=(BASE_STATS)
  end

  def birth
    us = url_status
    logger.debug us
    if us
      domain = URI.split(url)[2]
      dna = parse_dna(domain)
      build_stats(dna)
      logger.debug "Critter #{name} built from #{domain}: #{dna}"
    else
      errors.add :url, " is a facade.  Only true URLs are domains for critters."
      return false
    end
  end

end
