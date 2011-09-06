require 'uri'
require 'curb'

class Critter < ActiveRecord::Base
  belongs_to :user
  #attr_accessible :name, :url
  attr_accessor :dna
  validates :name, :presence => true
  validates :url, :presence => true,
                  :format => { :with => URI::regexp(%w(http https)) }
  validates :user_id, :presence => true
  before_create :birth

  # Stats to use at birth.
  BASE_STATS = {
    :sex => 'M',
    :level => 1,
    :hp => 10,
    :dodge => 1,
    :crit => 1,
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
    :fire => true,
    :earth => true,
    :water => true,
    :air => true,
    :light => true,
    :dark => true 
  }
  # Mapping of what attributes flag the elementals.
  ELEMENTS = {
    :fire => :fire_damage,
    :earth => :earth_damage,
    :water => :water_damage,
    :air => :air_damage,
    :light => :light_damage,
    :dark => :dark_damage
  }
  LETTERS = ("a".."z")
  NUMBERS = (0..9)
  SEXES = %w(M F)
  # Possible allele combonations with dominance
  ALLELE_PAIRS = [
    [:d, :d],
    [:d, :r],
    [:r, :d]
  ]
  # Genetics definition, by chromosome, then attribute name and trait symbol.
  GENETICS = {
    'e' => {
      :absorb_fire => :add_one_per_level
    },
    't' => {
      :dodge => :add_one
    },
    'a' => {
      :absorb_earth => :add_one_per_level
    },
    'o' => {
      :absorb_air => :add_one_per_level
    },
    'i' => {
      :absorb_water => :add_one_per_level
    },
    'n' => {
      :hp => :add_10_per_level
    },
    's' => {
      :earth_damage => :double
    },
    'r' => {
      :water_damage => :add_one_per_level
    },
    'h' => {
      :fire_damage => :double
    },
    'l' => {
      :air_damage => :unable
    },
    'd' => {
      :earth_damage => :add_one_per_level
    },
    'c' => {
      :crit => :add_one
    },
    'u' => {
      :fire_damage => :unable
    },
    'm' => {
      :absorb_fire => :unable
    },
    'f' => {
      :fire_damage => :add_one_per_level
    },
    'p' => {
      :physical_damage => :double
    },
    'g' => {
      :earth_damage => :unable
    },
    'w' => {
      :air_damage => :double
    },
    'y' => {
      :water_damage => :double
    },
    'b' => {
      :air_damage => :add_one_per_level
    },
    'v' => {
      :crit => :unable
    },
    'k' => {
      :absorb_earth => :unable
    },
    'x' => {
      :dodge => :unable
    },
    'j' => {
      :water_damage => :unable
    },
    'q' => {
      :absorb_air => :unable
    },
    'z' => {
      :absorb_water => :unable
    },
    0 => {
      :light_damage => :add_one_per_level
    },
    1 => {
      :light_damage => :unable
    },
    2 => {
      :absorb_light => :unable
    },
    3 => {
      :light_damage => :double
    },
    4 => {
      :absorb_light => :add_one_per_level
    },
    5 => {
      :dark_damage => :add_one_per_level
    },
    6 => {
      :dark_damage => :unable
    },
    7 => {
      :absorb_dark => :unable
    },
    8 => {
      :dark_damage => :double
    },
    9 => {
      :absorb_dark => :add_one_per_level
    }
  }

  def birth
    us = url_status
    if us
      domain = URI.split(url)[2]
      @dna = parse_dna(domain)
      self.attributes = build_stats(dna)
      logger.debug "Critter #{name} built from #{domain}: #{dna.inspect}"
    else
      errors.add :url, " is a facade.  Only true URLs are domains for critters."
      return false
    end
  end

  def url_status
    c = Curl::Easy.http_head url
    c.perform
    logger.debug "url_status for #{url} is #{c.response_code}"
    return (c.response_code == 200)
  end

  # Parse URL for DNA, but limit by char length to avoid alphabet critters.
  def parse_dna(url)
    result = {}
    LETTERS.each do |l|
      i = url.index(l)
      if url.include?(l) && !i.nil? && i < 18
        r = rand(ALLELE_PAIRS.length)
        result[l] = ALLELE_PAIRS[r]
      end
    end
    NUMBERS.each do |n|
      i = url.index(n)
      if url.include?(n) && !i.nil? && i < 18
        r = rand(ALLELE_PAIRS.length)
        result[n] = ALLELE_PAIRS[r]
      end
    end
    return result
  end

  # Run through DNA and apply symbol traits.
  # Supported traits :add_one_per_level, :add_10_per_level, :double, :unable
  def build_stats(dna)
    stats = BASE_STATS
    stats[:sex] = SEXES[rand(2)]
    # TODO: change mass assignment so attr_accessible security can be turned back on
    # dna = { a => 'AA' } where a is chromo and A is allele
    dna.each do |chromo, alleles|
      logger.debug "Processing dna: #{chromo} = #{alleles.inspect}"
      if (!alleles.include?(:d))
        logger.debug 'No dominant gene found in this allele, move to next chromosome.'
        next
      end
      genetics = GENETICS[chromo]
      logger.debug "Matching genetics: #{genetics.inspect}"
      genetics.each do |att, rule|
        logger.debug "Processing trait: #{att.inspect} => #{rule.inspect}"
        case rule
        when :add_one
          new_stat_value = add(stats[att], 1)
        when :add_one_per_level
          new_stat_value = add_per_level(stats[att], stats[:level], 1)
        when :add_10_per_level
          new_stat_value = add_per_level(stats[att], stats[:level], 10)
        when :double
          new_stat_value = double(stats[att])
        when :unable
          new_stat_value = unable()
        else
          logger.warn 'Unknown genetic trait, cannot process: ' + rule.to_s
        end
        logger.debug "Stat trasformation for #{att.inspect} from #{stats[att].inspect} to #{new_stat_value.inspect}"
        stats[att] = new_stat_value
      end # genetics.each
    end # dna.each

    ELEMENTS.each do |ele_att, power_att|
      if (stats[power_att] == 0)
        stats[ele_att] = false
      else
        stats[ele_att] = true
      end
      logger.debug "Element #{ele_att.inspect} flagged #{stats[ele_att]}"
    end

    logger.debug "critter#build_stats returning: #{stats.inspect}"
    return stats
  end

  def add(stat_value, increment)
    if (stat_value == 0)
      return 0
    end
    return (stat_value + increment)
  end

  def add_per_level(stat_value, level, increment)
    if (stat_value == 0)
      return 0
    end
    return (stat_value + (level * increment))
  end

  def double(stat_value)
    if (stat_value == 0)
      return 0
    end
    return stat_value * 2
  end

  def unable()
    return 0
  end

end
