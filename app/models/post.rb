class Post < ApplicationRecord

  #================================= Relationships ===============================================================

  belongs_to :company
  belongs_to :user, class_name: "User", foreign_key: :created_by
  has_many :commentries, dependent: :destroy
  has_and_belongs_to_many :tags, join_table: :posts_tags
  has_one_attached :image

  #================================ Validations ==================================================================

  validates :title, presence: true, uniqueness: { scope: :company_id }

  #================================= Scope ======================================================================

  scope :with_includes, -> { preload(:posts_tags, :commentries, :tags, image_attachment: :blob) }

  #=============================== Nested Attributes =============================================================

  accepts_nested_attributes_for :commentries, reject_if: :all_blank
  accepts_nested_attributes_for :tags

  #============================== Enum ==========================================================================

  enum status: [:live, :draft]

  #============================== Callbacks ======================================================================

  after_create_commit :send_email, if: -> { notification && status == "live" }
  after_save :update_preview_image_url, if: -> {main_url_previously_changed?}

  #============================== Methods ========================================================================

  def send_email
    PostsNotificationJob.set(wait: 5.seconds).perform_later(id)
  end

  def update_preview_image_url
    update(preview_image_url: get_preview_image_url)
  end

  def get_preview_image_url
    # Pulling image from given main URL using LinkThumbnailer
    begin
      page = MetaInspector.new(main_url, faraday_options: { ssl: { verify: false } },
                               :connection_timeout => 5, :read_timeout => 5)

      if page.meta_tags['property']['og:image'].present?
        preview_image_url = page.meta_tags['property']['og:image'].first if page.meta_tags['property']['og:image'].first != 'http:/'
      end
    rescue MetaInspector::TimeoutError, MetaInspector::RequestError, MetaInspector::ParserError, MetaInspector::NonHtmlError => e
      preview_image_url = nil
    end
    preview_image_url
  end
end
