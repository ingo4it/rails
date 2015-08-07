class ReferencesController < ApplicationController
  before_filter :signed_in_user
  before_filter :current_user_has_access?
  before_filter :retrieve_user 
  

  def create

    @reference = @user.references.build(params[:reference])
    @reference.auth_id = current_user.id
    if @reference.save
      flash[:success] = "Reference created!"
      redirect_to @user
    else
      render 'static_pages/home'
    end
  end
  
  private
  
    def retrieve_user
      redirect_to(root_url)  unless @user = User.find_by_id(params[:user_id])
    end

end
