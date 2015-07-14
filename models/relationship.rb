class Relationship < ActiveRecord::Base
  attr_accessible :contacted_id
  
  belongs_to :contacter, class_name: "User"
  belongs_to :contacted, class_name: "User"
  
  validates :contacter_id, presence: true
  validates :contacted_id, presence: true
end
