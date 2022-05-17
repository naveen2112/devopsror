class Card < ApplicationRecord

  #===================================================== Relationships =================================================

  belongs_to :user, counter_cache: true

  #===================================================== Validations ===================================================

  validates_presence_of :last_four_digits, :expiry, :token

  #=================================================== Callbacks ======================================================

  before_create :update_status

  #================================================== Methods =========================================================

  def update_status
    user.cards.update_all(default_card: false)
  end
end
