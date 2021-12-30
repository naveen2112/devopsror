class Tag < ApplicationRecord

  #============================== Relationships ==================================================================

  belongs_to :company
  has_and_belongs_to_many :posts, join_table: :posts_tags

  #=============================== Validations ===================================================================

  validates :name, presence: true
end
