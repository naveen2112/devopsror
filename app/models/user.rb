class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable

  #========================================= Relationships ============================================================

  belongs_to :company
  has_many :posts, foreign_key: :created_by
  has_many :cards, dependent: :destroy
  has_many :integrated_accounts, dependent: :destroy
  has_one_attached :logo

  #======================================== Attribute accessors ====================================================

  attr_accessor :current_password

  #========================================= Callbacks =============================================================

  after_create_commit :send_invite_email, if: -> { invited }

  #========================================= Scope ==================================================================

  scope :subscribers, -> { where(subscribe: true) }
  scope :owner_admin, -> { where("cards_count > ?", 0) }
  scope :date_filter, lambda { |star_date, end_date| where('DATE(created_at) > ? AND DATE(created_at) <= ?', star_date,
                                                           end_date) }
  scope :old_users, lambda { |star_date, end_date| where.not('DATE(created_at) > ? AND DATE(created_at) <= ?', star_date,
                                                           end_date) }

  #========================================= Validations ==============================================================

  validates_presence_of :first_name
  validate :check_user_limit, on: :create

  #======================================== Enum ======================================================================

  enum role: { admin: 0, poster: 1, editor: 2 }

  #============================================ Nested attributes =====================================================

  accepts_nested_attributes_for :company, reject_if: :all_blank
  accepts_nested_attributes_for :cards

  #=========================================== Methods ================================================================

  def name
    first_name + " " + last_name
  end

  def image_url
    logo.attached? ? logo.url : "/assets/user_thumb.png"
  end

  def send_invite_email
    UserMailer.invite_email(company_id, id).deliver_later
  end

  def linked_in_code
    integrated_accounts.with_platform("linked_in")&.first.nil? ? nil : integrated_accounts.with_platform("linked_in")&.last.data['access_token']
  end

  def social_account_integrated
    integrated_accounts.pluck(:platform).uniq.count
  end

  def total_posts
    posts.count
  end

  def check_user_limit
    errors.add(:user, "limit reached") if company&.user_limit.present? && company.users.count >= company.user_limit
  end
end
