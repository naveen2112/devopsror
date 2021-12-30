require 'activerecord-import'
class Company < ApplicationRecord

  #============================================ Relationships =========================================================

  has_many :users, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :tags, dependent: :destroy

  #======================================== Callbacks ================================================================

  after_create :create_tags

  #===================================== Methods ====================================================================

  def create_tags
    content = [{name: "Sales", company_id: id}, {name: "Announcement", company_id: id}, {name: "Other Tag", company_id: id}]
    Tag.import content, validate: true
  end
end
