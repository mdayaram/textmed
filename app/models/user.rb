class User < ActiveRecord::Base
  has_many :messages, -> { order "created_at" }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Validations
  # :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  # :phone
  validates_plausible_phone :phone_number, :presence => true
  validates :phone_number, uniqueness: true

  def phone_number=(new_num)
    self[:phone_number] = PhonyRails.normalize_number(new_num)
  end

  def last_message
    Message.where(user_id: self.id).order(created_at: :desc).first
  end

  def last_message_date!
    if last_message.nil?
      Time.new 0
    else
      last_message.created_at
    end
  end

  def last_sent_message
    Message.where(user_id: self.id, received: false).order(created_at: :desc).first
  end

  def last_received_message
    Message.where(user_id: self.id, received: true).order(created_at: :desc).first
  end

  def self.search_and_order(search)
    if search
      term = "%#{search.downcase}%"
      where("email LIKE ? OR name LIKE ? OR phone_number LIKE ?", term, term, term).order(
        admin: :desc, email: :asc
      )
    else
      order(admin: :desc, email: :asc)
    end
  end

  def self.last_signups(count)
    order(created_at: :desc).limit(count).select("id","email","created_at")
  end

  def self.last_signins(count)
    order(last_sign_in_at:
          :desc).limit(count).select("id","email","last_sign_in_at")
  end

  def self.users_count
    where("admin = ? AND locked = ?",false,false).count
  end
end
