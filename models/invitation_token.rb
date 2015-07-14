# == Schema Information
#
# Table name: invitation_tokens
#
#  id            :integer          not null, primary key
#  token         :string(255)
#  user_id       :integer
#  limit         :integer
#  invitee_count :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class InvitationToken < ActiveRecord::Base
  attr_accessible :limit, :user_id
  attr_readonly :token
  belongs_to :user
  has_many :invitees, :class_name => 'Identity'

  before_validation :generate_token
  validates_presence_of :token, :user_id
  validates_uniqueness_of :token

  scope :usable, where('"limit" > "invitee_count"')



  private
    
    def generate_token
      while token.blank? or InvitationToken.where(:token => token).exists?
        self.token = SecureRandom.urlsafe_base64(16)
      end
      true
    end
end
