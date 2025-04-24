class BlockTransactionsController < ApplicationController
  def index
    @block_transactions = ::BlockTransaction.successful.contains_transfer
  end
end