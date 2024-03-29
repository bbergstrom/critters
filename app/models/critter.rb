require 'uri'
require 'curb'
require 'public_suffix_service'

class Critter < ActiveRecord::Base
  belongs_to :user
  belongs_to :mother, :class_name => "Critter",
    :foreign_key => "mother_id"
  belongs_to :father, :class_name => "Critter",
    :foreign_key => "father_id"
  #attr_accessible :name, :url
  validates :name, :presence => true
  validates :url, :on => :create,
                  :domain_name => true,
                  :unless => :bred
  validates :user_id, :presence => true
  validates_with CritterLimitValidator, :on => :create
  before_create :birth
  serialize :dna

  # Stats to use at birth.
  BASE_STATS = {
    :sex => 'M',
    :bred => false,
    :level => 1,
    :quality => 0,
    :hp => 10,
    :dodge => 1,
    :crit => 1,
    :physical_damage => 1,
    :fire_damage => 0,
    :earth_damage => 0,
    :water_damage => 0,
    :air_damage => 0,
    :light_damage => 0,
    :dark_damage => 0,
    :absorb_fire => 0,
    :absorb_earth => 0,
    :absorb_water => 0,
    :absorb_air => 0,
    :absorb_light => 0,
    :absorb_dark => 0,
    :has_crit => true,
    :has_dodge => true,
    :has_fire_damage => true,
    :has_earth_damage => true,
    :has_water_damage => true,
    :has_air_damage => true,
    :has_light_damage => true,
    :has_dark_damage => true,
    :has_absorb_fire => true,
    :has_absorb_earth => true,
    :has_absorb_water => true,
    :has_absorb_air => true,
    :has_absorb_light => true,
    :has_absorb_dark => true 
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
      :has_air_damage => :unable
    },
    'd' => {
      :earth_damage => :add_one_per_level
    },
    'c' => {
      :crit => :add_one
    },
    'u' => {
      :has_fire_damage => :unable
    },
    'm' => {
      :has_absorb_fire => :unable
    },
    'f' => {
      :fire_damage => :add_one_per_level
    },
    'p' => {
      :physical_damage => :double
    },
    'g' => {
      :has_earth_damage => :unable
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
      :has_crit => :unable
    },
    'k' => {
      :has_absorb_earth => :unable
    },
    'x' => {
      :has_dodge => :unable
    },
    'j' => {
      :has_water_damage => :unable
    },
    'q' => {
      :has_absorb_air => :unable
    },
    'z' => {
      :has_absorb_water => :unable
    },
    '0' => {
      :light_damage => :add_one_per_level
    },
    '1' => {
      :has_light_damage => :unable
    },
    '2' => {
      :has_absorb_light => :unable
    },
    '3' => {
      :light_damage => :double
    },
    '4' => {
      :absorb_light => :add_one_per_level
    },
    '5' => {
      :dark_damage => :add_one_per_level
    },
    '6' => {
      :has_dark_damage => :unable
    },
    '7' => {
      :has_absorb_dark => :unable
    },
    '8' => {
      :dark_damage => :double
    },
    '9' => {
      :absorb_dark => :add_one_per_level
    }
  }

  def birth
    if !bred
      us = url_status
      if us
        self.domain = PublicSuffixService.parse(url.sub(/(http|https):\/\//, '')).domain.downcase
        self.dna = parse_dna(domain)
        self.attributes = build_stats(dna)
        logger.debug "Critter #{name} built from #{domain}: #{dna.inspect}"
      else
        errors.add :url, " is a facade.  Only non-redirecting domains are habitats for critters."
        return false
      end
    else
      self.url = 'Bred in captivity'
      self.domain = 'Bred'
      self.dna = breed_dna
      self.attributes = build_stats(dna)
    end
  end

  def breed_dna
    result = {}
    logger.debug "Breeding female #{mother.name} and male #{father.name}."
    LETTERS.each do |l|
      if mother.dna.include?(l) || father.dna.include?(l)
        result[l] = [:r, :r]
      end
      if mother.dna.include?(l)
        r = rand(mother.dna[l].length)
        result[l][0] = mother.dna[l][r]
      end
      if father.dna.include?(l)
        r = rand(father.dna[l].length)
        result[l][1] = father.dna[l][r]
      end
    end
    NUMBERS.each do |n|
      if mother.dna.include?(n) || father.dna.include?(n)
        result[n] = [:r, :r]
      end
      if mother.dna.include?(n)
        r = rand(mother.dna[n].length)
        result[n][0] = mother.dna[n][r]
      end
      if father.dna.include?(n)
        r = rand(father.dna[n].length)
        result[n][1] = father.dna[n][r]
      end
    end
    return result
  end

  def level_up
    if mother.nil? || father.nil? 
      return false
    end
    base = [mother.level, father.level].min
    return (base + 1)
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
      ns = n.to_s
      i = url.index(ns)
      if url.include?(ns) && !i.nil? && i < 18
        r = rand(ALLELE_PAIRS.length)
        result[ns] = ALLELE_PAIRS[r]
      end
    end
    return result
  end

  # Run through DNA and apply symbol traits.
  # Supported traits :add_one_per_level, :add_10_per_level, :double, :unable
  def build_stats(dna)
    stats = {}
    stats.merge!(BASE_STATS)
    stats[:level] = level_up || stats[:level]
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
          quality_change = 1
        when :add_one_per_level
          new_stat_value = add_per_level(stats[att], stats[:level], 1)
          quality_change = 1
        when :add_10_per_level
          new_stat_value = add_per_level(stats[att], stats[:level], 10)
          quality_change = 1
        when :double
          new_stat_value = double(stats[att])
          quality_change = 1
        when :unable
          new_stat_value = unable()
          quality_change = -1
        else
          logger.warn 'Unknown genetic trait, cannot process: ' + rule.to_s
        end
        logger.debug "Stat trasformation for #{att.inspect} from #{stats[att].inspect} to #{new_stat_value.inspect}. Quality change: #{quality_change}."
        stats[att] = new_stat_value
        stats[:quality] += quality_change
      end # genetics.each
    end # dna.each

    logger.debug "critter#build_stats returning: #{stats.inspect}"
    return stats
  end

  def add(stat_value, increment)
    return (stat_value + increment)
  end

  def add_per_level(stat_value, level, increment)
    return (stat_value + (level * increment))
  end

  def double(stat_value)
    return stat_value * 2
  end

  def unable()
    return false
  end

  def name_and_quality
    return "Level: #{level}, Quality: #{quality}, Name: #{name}"
  end

  def children
    Critter.where('mother_id = ? OR father_id = ?', id, id).order('created_at DESC')
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
#  quality          :integer
#  domain           :string(255)
#

