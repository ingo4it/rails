
class Reference < ActiveRecord::Base
  attr_accessible :content, :auth_id, :rating, :met_on_itsplatonic
  belongs_to :user
  
  POSITIVE = 'positive'
  NEGATIVE = 'negative'
  NEUTRAL  = 'neutral'
  
  validates :user_id, presence: true
  validates :rating, inclusion: {in: [POSITIVE, NEUTRAL, NEGATIVE]}
  
  scope :positive, where(:rating => POSITIVE)
  scope :negative, where(:rating => NEGATIVE)
  scope :neutral,  where(:rating => NEUTRAL)
end
