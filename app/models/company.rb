class Company < ApplicationRecord

  #============================================ Relationships =========================================================

  has_many :users, dependent: :destroy

  #============================================ Validations ===========================================================

  validates_presence_of :name
  validates_uniqueness_of :name
end
