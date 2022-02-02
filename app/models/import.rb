require 'csv'
require 'open-uri'
class Import < ApplicationRecord

  #============================== Relationships =======================================================================

  belongs_to :company
  has_one_attached :file
  has_one_attached :error_file

  #=============================== Attribute Accessors ==============================================================

  attr_accessor :current_user

  #============================ Enum =================================================================================

  enum status: { in_progress: 0, success: 1, failed: 2 }

  #============================ Callbacks ============================================================================

  after_create_commit :process_import

  #=========================== Methods ==============================================================================

  def process_import
    user = company.users.find(user_id)
    ImportJob.set(wait: 8.seconds).perform_later(id, company_id, user.email)
  end
end
