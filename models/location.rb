class Location < ActiveRecord::Base
  attr_accessible :address, :latitude, :longitude
  belongs_to :user
  
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
  
  def to_s
    address
  end
end
