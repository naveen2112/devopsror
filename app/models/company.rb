require 'activerecord-import'

class Company < ApplicationRecord

  #============================================ Constants =========================================================

  PRICE_PER_USER_PER_MONTH = 15
  PRICE_PER_USER_PER_YEAR = 150
  #============================================ Relationships =========================================================

  has_many :users, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :imports, dependent: :destroy
  has_many :integrated_accounts, dependent: :destroy
  has_many :post_user_shares, dependent: :destroy
  has_many :linkedin_social_actions, dependent: :destroy

  #======================================= Nested Attributes ========================================================

  accepts_nested_attributes_for :users

  #===================================== Validations ===============================================================

  validates_presence_of :name, :url
  validates :name, uniqueness: true

  #=================================== Scopes =======================================================================

  scope :product_led_plan, -> { where(plan_type: "product_led") }
  scope :subscription_started, -> { where.not(trail_end_date: nil) }
  scope :subscribed, -> { where(subscription_status: "active") }

  #======================================== Callbacks ================================================================

  after_create :create_tags
  before_create :set_next_billing_date

  #======================================== Enum ====================================================================

  enum plan_type: { sales_led: 0, product_led: 1 }
  enum subscription_status: { active: 0, cancelled: 1 }
  enum billing_type: {monthly: 0, yearly: 1}

  #===================================== Methods ====================================================================

  def create_tags
    content = [{ name: "Sales", company_id: id }, { name: "Announcement", company_id: id }, { name: "Other Tag", company_id: id }]
    Tag.import content, validate: true
  end

  def total_posts
    posts.count
  end

  def set_next_billing_date
    self.next_billing_date = (Date.current + 14)
  end

  def billed_amount
    billing_type == 'monthly' ? Company::PRICE_PER_USER_PER_MONTH * users.count : Company::PRICE_PER_USER_PER_YEAR * users.count
  end

  def total_login_count
    users.sum(:login_count)
  end

  def total_no_users_connected_to_linkedin
    integrated_accounts.pluck(:user_id).uniq.count
  end

  def user_limit_warning
    (80 * user_limit) / 100
  end

  def subscription_days_left
    (next_billing_date - subscription_cancelled_at).to_i > 0 ? (next_billing_date - subscription_cancelled_at).to_i : 0
  end

  def access_allowed?

    company_access = if self.sales_led?
                       self.active? ? true : false
                     else
                       if self.active?
                         true
                       else
                         self.cancelled? && subscription_cancelled_at < next_billing_date ? true : false
                       end
                     end

    company_access
  end

  def total_users_invited
    users.where(invited: true).count
  end

  def total_users
    users.count
  end

  def total_users_accepted
    users.where(accepted: true).count
  end

  def billable?
    plan_type == 'product_led' && trail_end_date.present? && subscription_status == 'active'
  end
end
