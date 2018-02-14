class User < ApplicationRecord
  # devise :timeoutable, timeout_in: 60.minutes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :lockable, :masqueradable,
         :recoverable, :rememberable, :trackable

  has_many :procedures, class_name: "Procedure", foreign_key: :creator_user
  validates :username,uniqueness: true
  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  before_validation :set_username
  attr_accessor :login, :prevalidate_username_uniqueness

  def set_username
    binding.pry
    if prevalidate_username_uniqueness  == true
      if username.blank?
        self.username = [name,father_last_name,mother_last_name].join("")
      end
      while User.where(username: username).exists?  do
        self.username = [name,father_last_name,mother_last_name,"#{rand(00..99)}"].join("")
      end
    end
  end


  def login
    binding.pry
    @login || self.username || self.email
  end

 def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
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
