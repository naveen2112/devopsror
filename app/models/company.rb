class Company < ApplicationRecord

  #============================================ Relationships =========================================================

  has_many :users, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :tags, dependent: :destroy

  #======================================== Callbacks ================================================================

  after_create :create_tags

  #===================================== Methods ====================================================================

  def create_tags
    ["Sales", "Announcement", "Other Tag"].each do |name|
      Tag.create(name: name, company_id: id)
    end
  end
end
