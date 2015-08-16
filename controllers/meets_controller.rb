class MeetsController < ApplicationController
  before_filter :signed_in_user
  before_filter :current_user_has_access?
  before_filter :correct_user, :only => [:destroy]
  
  def index
    result_set = Meet
    result_set = result_set.where("meets.user_id != ?", current_user.id)
    if params.has_key?(:query)
      result_set = result_set.where('meets.content @@ :query', :query => "%#{params[:query]}%")
    end
    result_set = result_set.order('meets.created_at DESC')
    @meets = result_set.paginate(page: params[:page])
  end

  def create
    @meet = current_user.meets.build(params[:meet])
    if @meet.save
      flash[:success] = "Meet created!"
      redirect_to :back
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @meet.destroy
    redirect_to :back
  end
  
  private

  def correct_user
    @meet = current_user.meets.find_by_id(params[:id])
    redirect_to root_url if @meet.nil?
  end
end