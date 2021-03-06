class User < ApplicationRecord
  # devise :timeoutable, timeout_in: 60.minutes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :lockable, :masqueradable,
         :rememberable, :trackable, :validatable
  
  acts_as_paranoid without_default_scope: true

  attr_reader :full_name

  has_many :procedures, class_name: "Procedure", foreign_key: :creator_user
  has_many :user_preferences
  has_many :preferences, through: :user_preferences
  has_many :permissions, as: :authorizable
  has_many :featurettes, through: :permissions
  has_many :groups, through: :user_groups
  has_many :user_groups, inverse_of: :user
  has_many :segments, through: :user_segments
  has_many :represented_segments, ->(o) { where('user_segments.representative = ?', true) }, through: :user_segments, class_name: "Segment"
  has_many :non_represented_segments, ->(o) { where('user_segments.representative = ? OR user_segments.representative IS NULL', false) }, through: :user_segments, class_name: "Segment"
  has_one :disclaimer

  has_many :user_segments
  has_many :prep_processes
  has_many :prep_step_fives, through: :prep_processes
  has_many :incomplete_prep_processes, ->(o) { where('prep_processes.completed_at IS NULL') }, class_name: 'PrepProcess'
  has_many :evidences
  has_many :messages
  has_many :evidences, through: :messages
  has_many :received_messages, class_name: 'Message', foreign_key: :receiver_id
  # The idea is that the user is assigned to the Segment through :user_segment but also
  # the prep_processes are linked to :users and :segments as the tasks that they do for the segment
  has_many :processed_segments, through: :prep_processes, foreign_key: :user_id, class_name: 'Segment'

  has_many :user_roles
  has_many :roles, through: :user_roles

  validates :username, uniqueness: true
  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true

  scope :common_users, -> { joins(user_roles: :role).where(roles: { id: Role.common.id }) }
  scope :admin_users, -> { joins(user_roles: :role).where(roles: { id: Role.admin.id }) }

  before_validation :set_username
  accepts_nested_attributes_for :permissions
  accepts_nested_attributes_for :user_groups, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :user_roles, allow_destroy: true
  attr_accessor :login, :prevalidate_username_uniqueness, :pre_encrypted_password

  def accepted_disclaimer?
    disclaimer ? disclaimer.accepted? : create_disclaimer
  end

  def accept_disclaimer
    disclaimer ? disclaimer.update(accepted: true) : create_disclaimer.update(accepted: true)
  end

  def messages_between_self_and(user)
    @messages_between_self_and || (@messages_between_self_and = Message.includes(Message::INCLUDES_BASE).
      where("(receiver_id = ? AND user_id = ?) OR (receiver_id = ? AND user_id = ?)", user.id, self.id, self.id, user.id).
      order(id: :desc))
  end

  def self.user_chats(user)
    (self.includes(
        received_messages: Message::INCLUDES_BASE,
        messages: Message::INCLUDES_BASE,
        user_segments: [:segment]
      ).find_by_sql(
        <<-SQL
          WITH senders as (
            SELECT DISTINCT "users".* FROM "users"
            INNER JOIN messages ON messages.user_id = users.id
            WHERE "users"."deleted_at" IS NULL
            AND "users"."id" != #{user.id}
            AND (messages.user_id = #{user.id} OR messages.receiver_id = #{user.id})
          ),
          receivers as (
            SELECT DISTINCT "users".* FROM "users"
            INNER JOIN messages oN messages.receiver_id = users.id
            WHERE "users"."deleted_at" IS NULL
            AND "users"."id" != #{user.id}
            AND (messages.user_id = #{user.id} OR messages.receiver_id = #{user.id})
          )
          SELECT senders.* FROM senders UNION SELECT receivers.* FROM receivers
        SQL
    ) | (default_users(user) - [user])).uniq
  end

  def self.default_users(user)
    if user.admin? || user.super_admin?
      self.joins(user_roles: :role)
    else
      self.joins(user_segments: :segment, user_roles: :role).
        where(user_segments: { segment_id: messageable_segments_ids(user) })
    end.where(user_roles: { role_id: messageable_roles(user).map(&:id) }).limit(10)
  end

  def self.messageable_roles(user)
    if user.only_common?
      [Role.common]
    elsif user.representative?
      [Role.common, Role.admin]
    else
      [Role.admin, Role.super_admin]
    end
  end

  def self.messageable_segments_ids(user)
    Segment.messageable_by(user).pluck(:id)
  end

  def represents_segment?(segment)
    user_segments.where(segment: segment, representative: true).present?
  end

  def self.from_segment(segment)
    joins(:user_segments).where(user_segments: { segment_id: segment.id })
  end

  def self.non_representative_users_from_segment(segment)
    from_segment(segment).where("user_segments.representative = ? OR user_segments.representative IS NULL", false)
  end

  def set_username
    if prevalidate_username_uniqueness  == true
      if username.blank?
        self.username = I18n.transliterate(full_name.gsub(" ", ''))
      end
      while User.where(username: username).exists?  do
        self.username = username + "#{rand(00..99)}"
      end
      true
    end
  end

  def represented_segments_and_descendant_ids
    self.represented_segments
      .map { |segment| segment.self_and_descendant_ids }.flatten
  end

  def login
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

  def admin?
    roles.any?(&:is_admin?)
  end

  def super_admin?
    roles.any?(&:is_super_admin?)
  end

  def common?
    roles.any?(&:is_common?)
  end

  def only_common?
    !representative? && common?
  end

  def representative?
    represented_segments.any? && common?
  end

  def root_segment
    if representative?
      represented_segments.first
    elsif admin? || super_admin?
      Segment.find_by(parent_id: nil)
    else
      nil
    end
  end

end
