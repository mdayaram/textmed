class User < ActiveRecord::Base
  has_many :messages, -> { order "created_at" }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Pagination
  paginates_per 100

  # Validations
  # :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  # :phone
  validates_plausible_phone :phone_number

  def last_sent_message
    Message.where(user_id: self.id, received: false).order(created_at: :desc).first
  end

  def last_received_message
    Message.where(user_id: self.id, received: true).order(created_at: :desc).first
  end

  def self.paged(page_number)
    order(admin: :desc, email: :asc).page page_number
  end

  def self.search_and_order(search, page_number)
    if search
      where("email LIKE ? or name LIKE ? or phone_number LIKE ?", "%#{search.downcase}%", "%#{search.downcase}%", "%#{search.downcase}%").order(
        admin: :desc, email: :asc
      ).page page_number
    else
      order(admin: :desc, email: :asc).page page_number
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
