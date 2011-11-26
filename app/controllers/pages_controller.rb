class PagesController < ApplicationController
  def home
    # The top and most recent 5 critters for the homepage feed.
    @top_critters = Critter.find(:all, :limit => 5, :order => 'level DESC')
    @recent_critters = Critter.find(:all, :limit => 5, :order => 'created_at DESC')
  end

  def about
  end

end
