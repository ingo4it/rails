#A Request is a response to another user's Meet
#The Request belongs_to the Meet to which it responds and that Meet belongs to the user that wrote it
#The user creating the request should be remembered in the field resp_id
class MeetRequestsController < ApplicationController
  before_filter :signed_in_user
  before_filter :current_user_has_access?
  before_filter :retrieve_meet

  def create
    req = @meet.meet_requests.build(user: current_user)
    if req.save
      flash[:success] = "Meet request submitted!"
      redirect_to new_conversation_path(:recipient_id => @meet.user_id, :suggested_subject => "RE: #{@meet.content}", :suggested_body => 'Remember to suggest a date, time and location')
    else
      flash[:error] = "Error submitting meet request"
      redirect_to :back
    end
  end

  private

    def retrieve_meet
      redirect_to(root_url)  unless @meet = Meet.find_by_id(params[:meet_id])
    end
end
