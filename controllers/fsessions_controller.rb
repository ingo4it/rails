class FsessionsController < ApplicationController

  # Fsessions provides the logic by which a profile, likes, interests, activities, and favorite teams are created.
  # Eventually, I'd like this to allow the user to update his/her profile by reauthenticating w/ Facebook
  # Commented code was used to explore objects returned by OmniAuth and Koala Facebook calls

  def create
  
    auth = request.env['omniauth.auth']
         
    unless signed_in?
      if u = User.find_by_facebook_id(auth.uid)
        sign_in u
      else
        u = User.new
        u.name = auth.extra.raw_info.first_name
        u.email = auth.info.email
        u.password = SecureRandom.hex(7)
        u.password_confirmation = u.password
        u.has_access = false
        u.assign_attributes({
          :provider => auth.provider,
          :oauth_token => auth.credentials.token,
          :oauth_expires_at => Time.at(auth.credentials.expires_at),
          :facebook_id => auth.uid
         }, :as => :registration)
        if u.save
          sign_in u
        else
          redirect_to root_url
        end
      end
    end
    
    # Receive data from facebook and save oauth_token for Koala usage
    
    @user = current_user
    sign_in @user
    
    auth_token = @user.oauth_token
    graph = Koala::Facebook::API.new(auth_token)
    person = graph.get_object("me")
    bigpic = graph.get_picture("me", :type => 'large')
    
    # render :text => auth.info.image
    
    # If profile exists, overwrite with data from Facebook, else create new profile with FB data
    @user.build_profile() unless @user.profile
    @user.profile.update_attributes(
      :first_name => auth.extra.raw_info.first_name,
      :last_name => auth.extra.raw_info.last_name,
      :gender => (auth.extra.raw_info.gender).capitalize,
      :religion => auth.extra.raw_info.religion,
      :political => auth.extra.raw_info.political,
      :birthday => (Date.strptime(auth.extra.raw_info.birthday, "%m/%d/%Y") rescue nil),
      :fam_stat => auth.extra.raw_info.relationship_status,
      :picture => auth.info.image,
      :bigpic => bigpic
    )
    
    # @user.build_location(:address => auth.extra.raw_info.location.name)
    
    #Empty user interests and populate with current data from FB
    @user.interests = []
    graph.get_connection("me", "interests").each do |hash|
      @user.interests << Interest.where(:obj_id => hash['id']).first_or_create(:name => hash['name'])
    end
    
    #Empty user activities and populate with current data from FB
    @user.activities = []
    graph.get_connection("me", "activities").each do |hash|
      @user.activities << Activity.where(:obj_id => hash['id']).first_or_create(:name => hash['name'])
    end
    
    #Empty user likes and populate with current data from FB
    @user.likes = []
    graph.get_connection("me", "likes").each do |hash|
      @user.likes << Like.where(:obj_id => hash['id']).first_or_create(:name => hash['name'])
    end
    
    # sudo code for teams - needs to be stripped from auth hash
    # person.favorite_teams.each do |hash|
    #   @user.teams.where(:name => hash['name'], :uid => hash['id']).first_or_create
    # end
     
    
    redirect_to root_url
  end
 
  # def destroy
  #   fsession[:user_id] = nil
  #   redirect_to root_url
  # end
end
