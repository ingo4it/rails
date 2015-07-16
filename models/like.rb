# == Schema Information
#
# Table name: facebook_objects
#
#  id         :integer          not null, primary key
#  obj_id     :integer

#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string(255)
#

class Like < FacebookObject
end
