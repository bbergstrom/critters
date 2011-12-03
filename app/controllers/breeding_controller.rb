class BreedingController < ApplicationController
  def new
    @males = Critter.where(:sex => 'M').order('level DESC, quality DESC, name ASC')
    @females = Critter.where(:sex => 'F').order('level DESC, quality DESC, name ASC')
  end

  def create
    female = Critter.find(params[:female])
    male = Critter.find(params[:male])
    @child = current_user.critters.new
    @child.name = "Child"
    @child.bred = true
    @child.mother = female
    @child.father = male
    if @child.save
      redirect_to(@child, :notice => 'A new critter was bred!')
    else
      @males = Critter.where(:sex => 'M').order('level DESC, quality DESC')
      @females = Critter.where(:sex => 'F').order('level DESC, quality DESC')
      flash.now[:error] = 'The critters were not in the mood to breed today.'
      render :action => 'new'
    end
  end

  def index
    redirect_to new_breeding_path
  end

end
