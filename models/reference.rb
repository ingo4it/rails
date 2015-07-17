# == Schema Information
#
# Table name: references
#
#  id                 :integer          not null, primary key
#  content            :string(255)
#  user_id            :integer
#  auth_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  rating             :string(255)
#  met_on_itsplatonic :boolean
#

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
