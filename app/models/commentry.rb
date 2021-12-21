class Commentry < ApplicationRecord

  #================================== Relationships ===============================================================

  belongs_to :post
  has_one_attached :image

  #================================== Validations =================================================================

  validates_presence_of :description
end
