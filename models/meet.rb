class Meet < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  has_many :meet_requests
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
  default_scope order: 'meets.created_at DESC'
end
