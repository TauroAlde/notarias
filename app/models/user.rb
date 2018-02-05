class User < ApplicationRecord
  # devise :timeoutable, timeout_in: 60.minutes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :procedures, class_name: "Procedure", foreign_key: :creator_user
  has_many :groups, through: :user_group

  def lock_access!
    self.locked_at = Time.now.utc
    save  
  end

  def unlock_access!
    self.locked_at = nil
    save
  end

end
