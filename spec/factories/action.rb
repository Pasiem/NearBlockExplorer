FactoryBot.define do
  factory :action do
    action_type { "Transfer" }
    data { { "deposit" => "9999800000000000000000000000" } }
    block_transaction factory: :block_transaction
  end
end