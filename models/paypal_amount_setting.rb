class PaypalAmountSetting < ActiveRecord::Base

  validates :amount_to_show, :presence => true
  validates :amount_to_show, numericality: {greater_than: 0}


  validates :amount_to_charge, :presence => true
  validates :amount_to_charge, numericality: {greater_than: 0, :only_integer => true}

  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**User::ROLES.index(role.to_s)} > 0"} }


  def roles=(roles)
    self.roles_mask = (roles & User::ROLES).map { |r| 2**User::ROLES.index(r) }.inject(0, :+)
  end

  def roles
    User::ROLES.reject do |r|
      ((roles_mask || 0) & 2**User::ROLES.index(r)).zero?
    end
  end

  def is?(role)
    roles.include?(role.to_s)
  end

end
