class Post < ApplicationRecord

  #================================= Relationships ===============================================================

  belongs_to :company
  has_many :commentries, dependent: :destroy
  has_and_belongs_to_many :tags, join_table: :posts_tags

  #================================ Validations ==================================================================

  validates_presence_of :title

  #=============================== Nested Attributes =============================================================

  accepts_nested_attributes_for :commentries
  accepts_nested_attributes_for :tags
end
