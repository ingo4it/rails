
class Profile < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :postal_code, :birthday, :age,
                  :gender, :fam_stat, :religion, :education, :occupation, :political,
                  :picture, :bigpic
  belongs_to :user
  
  before_save :attach_pictures
  
  validates :user_id, presence: true
  
  private
    def attach_pictures
      self.picture ||= 'http://profile.ak.fbcdn.net/static-ak/rsrc.php/v2/y9/r/IB7NOFmPw2a.gif'
      self.bigpic ||= 'https://fbcdn-profile-a.akamaihd.net/static-ak/rsrc.php/v2/yp/r/yDnr5YfbJCH.gif'
      true
    end
end
