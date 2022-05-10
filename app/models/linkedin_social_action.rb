class LinkedinSocialAction < ApplicationRecord

  #============================================ Relationships =========================================================
  belongs_to :company
  belongs_to :post

  #======================================== Enum ====================================================================
  enum action_type: { link_click: 0 }
  enum platform: { linkedin: 0 }

  #================================= Scope ======================================================================
  scope :filter_date, ->(from_date, to_date) { where('created_at >= (?) AND created_at <= (?)', from_date, to_date) }
end
