FactoryBot.define do
  factory :block_transaction do
    trans_hash { "DJKSVBKBVEIRBVIUHTBVILRUWtB#{Random.rand(0002..9999)}" } 
    sender { "sender1" } 
    receiver { "receiver1" } 

    success { true }

    contains_transfer { true } 
    transfer_deposit { "0" }
  end
end