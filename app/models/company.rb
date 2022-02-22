require 'activerecord-import'
class Company < ApplicationRecord

  #============================================ Relationships =========================================================

  has_many :users, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :imports, dependent: :destroy
  has_many :integrated_accounts, dependent: :destroy

  #======================================= Nested Attributes ========================================================

  accepts_nested_attributes_for :users

  #======================================== Callbacks ================================================================

  after_create :create_tags

  #===================================== Methods ====================================================================

  def create_tags
    content = [{name: "Sales", company_id: id}, {name: "Announcement", company_id: id}, {name: "Other Tag", company_id: id}]
    Tag.import content, validate: true
  end

  def total_posts
    posts.count
  end

  def total_login_count
    users.sum(:login_count)
  end

  def total_users_connected_one_social_account
    integrated_accounts.pluck(:user_id).uniq.count
  end
end
