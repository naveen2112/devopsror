class Commentry < ApplicationRecord

  #================================== Relationships ===============================================================

  belongs_to :post

  #================================== Validations =================================================================

  validates_presence_of :description
end
