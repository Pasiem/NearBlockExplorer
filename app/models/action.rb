class Action < ApplicationRecord
  belongs_to :block_transaction, inverse_of: :actions, optional: false
  validates_associated :block_transaction

  validates :action_type, presence: true
  validates :data, presence: true
end