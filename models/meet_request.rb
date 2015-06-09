

class MeetRequest < ActiveRecord::Base
  attr_accessible :user_id, :user

  belongs_to :meet
  belongs_to :user

  validates :meet_id, presence: true
  validates :user_id, presence: true, exclusion: {in: lambda { |mr| [mr.meet.user.id] }}
end
