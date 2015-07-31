
class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :show, :contacting, :contacters]
  before_filter :current_user_has_access?, only: [:index, :edit, :update, :show, :contacting, :contacters]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: [:destroy]
  
  respond_to :html, :json
  
  def show
    @user = User.find(params[:id])
    @profile = @user.profile
    @meets = @user.meets.paginate(page: params[:page])
    @references = @user.references.paginate(page: params[:page])
    
    @likes = @user.likes
    @activities = @user.activities
    @interests = @user.interests
    @teams = @user.teams
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Its Platonic!"
      redirect_to new_user_profile_path(@user)
    else
      render 'static_pages/home', :layout => nil
    end
  end
  
  def edit
    #@user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "User Info Updated"
      sign_in @user
    else
      render 'edit'
    end
    respond_with @user
  end
  
  def index
    # drinking_habits: ''
    # drinking_at: ''
    # spend: '15'
    # area: ''
    # city: ''
    # reply_rate: '0'
    # references_from: ''
    # common_friends: '1'
    # subscription_status: 'subscribed'
    result_set = User
    if params[:age_range].present?
      result_set = result_set.includes(:profile)
      if params[:age_range][:start].present?
        result_set = result_set.where(["profiles.birthday <= :start", :start => params[:age_range][:start].to_i.years.ago.to_date])
      end
      if params[:age_range][:end].present?
        result_set = result_set.where(["profiles.birthday >= :end", :end => params[:age_range][:end].to_i.years.ago.to_date])
      end
    end
    if params[:gender].present?
      result_set = result_set.includes(:profile).where(:'profiles.gender' => params[:gender])
    end
    if params[:query].present?
      result_set = result_set.includes(:facebook_objects).where("facebook_objects.name @@ :query", :query => "%#{params[:query]}%")
    end
    if params[:family_status].present?
      result_set = result_set.includes(:profile).where(:'profiles.fam_stat' => params[:family_status])
    end
    if params[:occupation].present?
      result_set = result_set.includes(:profile).where(:'profiles.occupation' => params[:occupation])
    end
    if params[:education].present?
      result_set = result_set.includes(:profile).where(:'profiles.education' => params[:education])
    end
    # if params[:references_no].present?
    #   result_set = result_set.includes(:references).group(:'references.user_id').having('count(references.id) >= ?', params[:references_no])
    # end
    @users = result_set.paginate(page: params[:page])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  def contacting
    @title = "Contacting"
    @user = User.find(params[:id])
    @users = @user.contacted_users.paginate(page: params[:page])
    render 'show_contact'
  end

  def contacters
    @title = "Contacters"
    @user = User.find(params[:id])
    @users = @user.contacters.paginate(page: params[:page])
    render 'show_contact'
  end
    
  private

    
    #def correct_user
    #  @user = User.find(params[:id])
    #  redirect_to(root_path) unless current_user?(@user)
    #end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
