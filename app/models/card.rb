class Card < ApplicationRecord

  #===================================================== Relationships =================================================

  belongs_to :user

  #===================================================== Validations ===================================================

  #validates_presence_of :number, :expiry, :token
end
