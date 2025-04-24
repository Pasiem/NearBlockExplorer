class BlockTransaction < ApplicationRecord
  has_many :actions, inverse_of: :block_transaction
 
  # Scopes to be used for filtering valid transactions to be displayed in index page
  # Filtering for successful transfers based off the assumption that only Transactions
  # with a success are valid for display.
  scope :contains_transfer, -> {where(contains_transfer: true)}
  scope :successful, -> {where(success: true)}
 
  validates :sender, presence: true
  validates :receiver, presence: true
  validates :trans_hash, presence: true, uniqueness: true

  # Ensure the presence of transfer_deposit if the Transaction contains an action of type Transfer
  validates :transfer_deposit, presence: { message: "can't be blank if Contains transfer" }, if: -> { contains_transfer }
end