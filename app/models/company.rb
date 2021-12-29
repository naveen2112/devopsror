class Company < ApplicationRecord

  #============================================ Relationships =========================================================

  has_many :users, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :tags, dependent: :destroy

  #======================================== Callbacks ================================================================

  after_create :create_tags

  #===================================== Methods ====================================================================

  def create_tags
    Tag.create(name: "Sales", company_id: id)
    Tag.create(name: "Announcement", company_id: id)
    Tag.create(name: "Other Tag", company_id: id)
  end
end
