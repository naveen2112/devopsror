require 'activerecord-import'
class Company < ApplicationRecord

  #============================================ Relationships =========================================================

  has_many :users, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :imports, dependent: :destroy

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
    total_users = []

    User.all.each do |user|
      total_users << user if user.social_account_integrated > 0
    end

    total_users.count
  end
end
