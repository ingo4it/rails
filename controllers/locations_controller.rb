
class LocationsController < ApplicationController
  before_filter :retrieve_user
  
  def show
    @location = Location.find(params[:id])
  end

  def new
    @location = Location.new
  end

  def create
    @location = @user.build_location(params[:location])
    if @location.save
      redirect_to @user, :notice => "Successfully created location."
    else
      render :action => 'new'
    end
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:location])
      redirect_to @user, :notice  => "Successfully updated location."
    else
      render :action => 'edit'
    end
  end
  
private
  def retrieve_user
    (@user = User.find_by_id(params[:user_id])) || redirect_to(root_url)
  end
end
