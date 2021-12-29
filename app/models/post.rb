class Post < ApplicationRecord

  #================================= Relationships ===============================================================

  belongs_to :company
  has_many :commentries, dependent: :destroy
  has_and_belongs_to_many :tags, join_table: :posts_tags
  has_one_attached :image

  #================================ Validations ==================================================================

  validates_presence_of :title

  #=============================== Nested Attributes =============================================================

  accepts_nested_attributes_for :commentries, reject_if: :all_blank
  accepts_nested_attributes_for :tags

  #============================== Enum ==========================================================================

  enum status: [:posted, :draft]

  #============================== Callbacks ======================================================================

  after_create :send_email, if: -> { notification && status == "posted" }

  #============================== Methods ========================================================================

  def send_email
    PostsNotificationJob.perform_later(id)
  end
end
