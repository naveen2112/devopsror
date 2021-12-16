class Company < ApplicationRecord

  #============================================ Relationships =========================================================

  has_many :users, dependent: :destroy
end
