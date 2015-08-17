class ProfilesController < ApplicationController
  before_filter :signed_in_user
  before_filter :current_user_has_access?
  #before_filter :correct_user,   only: [:new, :create, :edit, :update, :destroy]

  
  def show
    @user = User.find(params[:user_id])
    @profile = @user.profile
    #@profile = Profile.find(params[:id])
  end
  
  def new
    @user = current_user
    @profile = @user.build_profile()
  end
  
  def create
    @user = current_user
    @profile = @user.build_profile(params[:profile])

    if @profile.save
      flash[:success] = "Profile created!"
      redirect_to root_url
    else
      render 'static_pages/faqs'
    end
  end
  
  def edit
    @user = current_user
    @profile = @user.profile
  end
  
  def update
    @user = current_user
    @profile = @user.profile
    #@profile = User.find(params[:id]).profile
    if @profile.update_attributes(params[:profile])
      flash[:success] = "Profile Updated"
      redirect_to root_url
    else
      render 'edit'
    end
  end
      
  def destroy
  end
end
