class CrittersController < ApplicationController
  # GET /critters
  def index
    @title = "Your Critters"
    #@critters = Critter.all
    @critters = current_user.critters

    # index.html.erb
  end

  # GET /critters/1
  # GET /critters/1.xml
  def show
    @critter = Critter.find(params[:id])

    # show.html.erb
  end

  # GET /critters/new
  def new
    @critter = Critter.new

    # new.html.erb
  end

  # GET /critters/1/edit
  def edit
    @critter = Critter.find(params[:id])
  end

  # POST /critters
  def create
    @critter = current_user.critters.build(params[:critter])
    #@critter.build_critter
    if @critter.save
      redirect_to(@critter, :notice => 'Critter was successfully created.')
    else
      render :action => "new", :notice => 'You didn\'t find any creatures hiding here.  Try another corner of the web.'
    end
  end

  # PUT /critters/1
  def update
    @critter = Critter.find(params[:id])

    if @critter.update_attributes(params[:critter])
      redirect_to(@critter, :notice => 'Critter was successfully updated.')
    else
      render :action => "edit" 
    end
  end

  # DELETE /critters/1
  def destroy
    @critter = Critter.find(params[:id])
    @critter.destroy
    redirect_to(critters_url)
  end
end
