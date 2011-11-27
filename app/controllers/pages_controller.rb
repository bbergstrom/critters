class PagesController < ApplicationController
  def home
    # The top and most recent 5 critters for the homepage feed.
    @top_critters = Critter.find(:all, :limit => 10, :order => 'level DESC, quality DESC')
    @recent_critters = Critter.find(:all, :limit => 10, :order => 'created_at DESC')
  end

  def about
    @title = 'About'
  end

end
