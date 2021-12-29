class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #========================================= Relationships ============================================================

  belongs_to :company
  has_many :cards, dependent: :destroy

  #========================================= Validations ==============================================================

  validates_presence_of :first_name

  #======================================== Enum ======================================================================

  enum role: [:admin, :editor,  :poster]

  #============================================ Nested attributes =====================================================

  accepts_nested_attributes_for :company, reject_if: :all_blank
  accepts_nested_attributes_for :cards

  #=========================================== Methods ================================================================

  def name
    first_name + ' ' + last_name
  end  
end
