class Card < ApplicationRecord

  #===================================================== Relationships =================================================

  belongs_to :user, counter_cache: true

  #===================================================== Validations ===================================================

  validates_presence_of :last_four_digits, :expiry, :token
end
