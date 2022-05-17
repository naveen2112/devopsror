class PostUserShare < ApplicationRecord

  #============================================ Relationships =========================================================
  belongs_to :post
  belongs_to :user
  belongs_to :company
  #================================= Scope ======================================================================

  scope :filter_date, ->(from_date, to_date) { where('created_at >= (?) AND created_at <= (?)', from_date, to_date) }
end
