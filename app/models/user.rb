class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #========================================= Relationships ============================================================

  belongs_to :company
  has_many :posts, foreign_key: :created_by
  has_many :cards, dependent: :destroy
  has_many :integrated_accounts, dependent: :destroy
  has_one_attached :logo

  #========================================= Callbacks =============================================================

  after_create :send_invite_email, if: -> { (self.poster? || self.editor?) && invited }

  #========================================= Scope ==================================================================

  scope :subscribers, -> { where(subscribe: true) }

  #========================================= Validations ==============================================================

  validates_presence_of :first_name

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
end
