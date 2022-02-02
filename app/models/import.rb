class Import < ApplicationRecord

  #============================== Relationships =======================================================================

  belongs_to :company
  has_one_attached :file

  #============================ Enum =================================================================================

  enum status: { in_progress: 0, success: 1, failed: 2 }

  #============================ Callbacks ============================================================================

  after_create_commit :process_import

  #=========================== Methods ==============================================================================

  def process_import
    ImportJob.perform_later(id)
  end
end
