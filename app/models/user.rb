class User < ApplicationRecord
  # devise :timeoutable, timeout_in: 60.minutes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :lockable, :masqueradable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :procedures, class_name: "Procedure", foreign_key: :creator_user
  validates :username,uniqueness: true

  before_validation :set_username

  def set_username
    binding.pry
    if User.where(username: username).blank?
      self.username = [name,father_last_name,mother_last_name].join("")
    else
      if User.where(username: username).exists?
        while User.where(username: username).exists?  do
          self.username = [name,father_last_name,mother_last_name,"#{rand(00..99)}"].join("")
        end
      end
    end
  end

  def lock_access!
    self.locked_at = Time.now.utc
    save  
  end

  def unlock_access!
    self.locked_at = nil
    save
  end

  def full_name
    [name,father_last_name,mother_last_name].join(" ")  
  end
end
