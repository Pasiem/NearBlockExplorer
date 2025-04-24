class UpdateTransactions
  include Sidekiq::Worker
  sidekiq_options queue: :default

  def perform
    api = NearApi.new
    transactions = api.fetch_transactions

    transactions.each do |transaction|
      # If the transaction has already been stored in the db skip to the next.
      # I considered using a break statement, however if the order of the transactions
      # returned by the API is either random or oldest to newest then data will be lost.
      # The trade off here is extra computation to ensure data accuracy.
      next if ::BlockTransaction.exists?(trans_hash: transaction["hash"])

      ActiveRecord::Base.transaction do
        block = ::BlockTransaction.create!(trans_hash: transaction["hash"], 
                            sender: transaction["sender"], 
                            receiver: transaction["receiver"], 
                            trans_id: transaction["id"],
                            success: transaction["success"],
                            gas_burnt: transaction["gas_burnt"],
                            block_hash: transaction["block_hash"],
                            height: transaction["height"],
                            trans_time: transaction["time"],
                            contains_transfer: contains_transfer?(transaction["actions"]), 
                            transfer_deposit: transfer_deposit(transaction["actions"]))
        
        transaction["actions"].each do |action|
          action = block.actions.build(action_type: action["type"], data: action["data"])
          action.save!
        end
      end
    end
  end

  def contains_transfer?(actions)
    actions.each do |act|
      return true if act.dig("type") == "Transfer"
    end
    false
  end

  # For now the value of the Transaction deposit is inferred from it's 'last' and only action. 
  # In future this function could be modified to aggregate deposit values across multiple actions.
  def transfer_deposit(actions)
    act = actions.last

    return unless act.dig("type") == "Transfer"
    
    act.dig("data", "deposit")
  end
end
