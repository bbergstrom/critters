class PagesController < ApplicationController
  def home
    # The top 10
    @critters = Critter.find(:all, :limit => 10, :order => 'level DESC')
  end

  def about
  end

end
