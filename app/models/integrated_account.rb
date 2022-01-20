class IntegratedAccount < ApplicationRecord

  #=================================== Relationships =================================================================

  belongs_to :user

  #=================================== Scope ========================================================================

  scope :with_platform, -> (name) { where(platform: name) }

  #================================== Enum ==========================================================================

  enum platform: [:facebook, :twitter, :linked_in]
end
