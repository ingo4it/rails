
class Match < ActiveRecord::Base
  attr_accessible :matched_id

  belongs_to :matcher, class_name: "User"
  belongs_to :matched, class_name: "User"

  validates :matcher_id, presence: true
  validates :matched_id, presence: true

  scope :for_user_pair, lambda { |user1, user2| where("(matcher_id = :user1_id AND matched_id = :user2_id) OR (matcher_id = :user2_id AND matched_id = :user1_id)", user1_id: user1.id, user2_id: user2.id) }
  
  # def calculate
    # #compare the profile of two users and assign value to match.score
  # end
#   
  # def self.calculate_all_scores
  #   User.each_batch do |user|
  #     user.update_facebook_objects
  #     matching = user.matching_users.nearby # has_many :matching_users, :through => :facebook_objects
  #     matching.each do |score, other_users|
  #       other_users.each do |other_user|
  #         match = Match.where(:matcher => user, :matched => other_user).or.where(:matched => other_user...).first
  #         match ||= Match.new(:matcher => user, :matched => other_user)
  #         match.score = score
  #         match.save
  #       end
  #     end
  #   end
  # end
#   
  # def self.calculate_score(user_a, user_b)
    # ...
  # end
#   
  # def self.cache_common_elements
    # all.each do |match|
      # match.common_elements = find_top_four_commonalities(match.matcher, match.matched)
      # match.save
    # end
  # end
  
end
