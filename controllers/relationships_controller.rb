#A Relationship represents contact between two users
#The user thzt initiates contact is the contacter represented by contacter_id
#The user being contacted is represented by contacted_id

class RelationshipsController < ApplicationController
  before_filter :signed_in_user
  before_filter :current_user_has_access?

  respond_to :html, :js
  
  def create
    @user = User.find(params[:relationship][:contacted_id])
    
    current_user.contact!(@user)
    respond_with @user
  end

  def destroy
    @user = Relationship.find(params[:id]).contacted
    current_user.uncontact!(@user)
    respond_with @user
  end
end