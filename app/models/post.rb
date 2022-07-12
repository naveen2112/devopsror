class Post < ApplicationRecord

  #================================= Relationships ===============================================================

  belongs_to :company
  belongs_to :user, class_name: "User", foreign_key: :created_by, optional: true
  has_many :commentries, dependent: :destroy
  has_and_belongs_to_many :tags, join_table: :posts_tags
  has_one_attached :image
  has_many :post_user_shares, dependent: :destroy
  has_many :linkedin_social_actions, dependent: :destroy

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
  after_save :update_preview_image_url_and_title, if: -> {main_url.present? && main_url_previously_changed?}
  after_create :change_post_status, if: -> {user.blank?}

  #============================== Methods ========================================================================

  def send_email
    PostsNotificationJob.set(wait: 5.seconds).perform_later(id)
  end

  def update_preview_image_url_and_title
    preview_image_url, preview_url_title = get_preview_image_url_and_title
    update(preview_image_url: preview_image_url, preview_url_title: preview_url_title)
  end

  def get_preview_image_url_and_title
    # Pulling image and title from given main URL using MetaInspector
    begin
      page = MetaInspector.new(main_url, faraday_options: { ssl: { verify: false } },
                               :connection_timeout => 5, :read_timeout => 5)

      page_title = page.title
      if page.meta_tags['property']['og:image'].present?
        preview_image_url = page.meta_tags['property']['og:image'].first if page.meta_tags['property']['og:image'].first != 'http:/'
      end
    rescue MetaInspector::TimeoutError, MetaInspector::RequestError, MetaInspector::ParserError, MetaInspector::NonHtmlError => e
      preview_image_url, page_title = nil
    end
    [preview_image_url, page_title ]
  end

  def change_post_status
    update_columns(status: 'draft')
  end

  def encode_id
    Hashids.new('E/D object id', 8).encode(id)
  end
end
