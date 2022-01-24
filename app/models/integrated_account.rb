class IntegratedAccount < ApplicationRecord

  #=================================== Relationships =================================================================

  belongs_to :user

  #=================================== Scope ========================================================================

  scope :with_platform, -> (name) { where(platform: name) }

  #================================== Enum ==========================================================================

  enum platform: {linked_in: 1, facebook: 2, twitter: 3}

  #================================== Validations ==================================================================

  validates_presence_of :data
end
