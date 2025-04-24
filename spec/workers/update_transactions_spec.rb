require 'rails_helper'

RSpec.describe UpdateTransactions do
  describe '#contains_transfer?' do
    context 'when action is of type Transfer' do
      let(:actions) do
         [
          {
              "data" => {
                  "deposit" => "9999800000000000000000000000"
              },
              "type" => "Transfer"
          }
        ]
      end

      it 'returns true' do
        expect(UpdateTransactions.new.contains_transfer?(actions)).to eq(true)
      end
    end

    context 'when action is not of type Transfer' do
      let(:actions) do
        [
          {
              "data" => {
                  "gas" => 100000000000000,
                  "deposit" => "0",
                  "method_name" => "add_request_and_confirm"
              },
              "type" => "FunctionCall"
          }
        ]
      end
      
      it 'returns false' do
        expect(UpdateTransactions.new.contains_transfer?(actions)).to eq(false)
      end
    end
  end

  describe '#transfer_deposit' do
    let(:actions) do 
      [
        {
            "data" => {
                "deposit" => "9999800000000000000000000000"
            },
            "type" => "Transfer"
        }
      ]
    end

    it 'returns deposit value of the last action' do
      expect(UpdateTransactions.new.transfer_deposit(actions)).to eq("9999800000000000000000000000")
    end
  end

  describe '#perform' do
    let(:api) { double() }
    context 'when incoming transaction does not exist in BlockTransactions' do
      before do
        res = [{"id" => 208851,
                "created_at" => "2021-01-11T10:20:13.70879-06:00",
                "updated_at" => "2021-01-11T10:20:13.70879-06:00",
                "time" => "2021-01-11T10:20:04.132926-06:00",
                "height" => 27326763,
                "hash" => "6RtU9UkAQaJBVMrgvtDiARxzbhx1vKrwoTv4aZRxxgt7",
                "block_hash" => "FrWmh1BtBc8yvAZPJrJ97nVth6eryukbLANyFQ3TuQai",
                "sender" => "86e6ebcc723106eee951c344825b91a80b46f42ff8b1f4bd366f2ac72fab99d1",
                "receiver" => "d73888a2619c7761735f23c798536145dfa87f9306b5f21275eb4b1a7ba971b9",
                "gas_burnt" => "424555062500",
                "actions" => [{"data" => {"deposit" => "716669915088987500000000000"}, "type" => "Transfer"}],
                "actions_count" => 1,
                "success" => true}]
        allow(NearApi).to receive(:new).and_return(api)
        allow(api).to receive(:fetch_transactions).and_return(res)
      end

      it 'correctly creates new BlockTransaction and Action' do
        expect{ UpdateTransactions.new.perform }.to change {BlockTransaction.count}.by(1)
        block = BlockTransaction.where(trans_hash: "6RtU9UkAQaJBVMrgvtDiARxzbhx1vKrwoTv4aZRxxgt7").first
        action = block.actions.first
        expect(action.data).to eq({"deposit" => "716669915088987500000000000"})
        expect(action.action_type).to eq("Transfer")
      end
    end

    context 'when incoming transaction already exists in BlockTransaction table' do
      before do
        res = [{"id" => 208851,
                "created_at" => "2021-01-11T10:20:13.70879-06:00",
                "updated_at" => "2021-01-11T10:20:13.70879-06:00",
                "time" => "2021-01-11T10:20:04.132926-06:00",
                "height" => 27326763,
                "hash" => "6RtU9UkAQaJBVMrgvtDiARxzbhx1vKrwoTv4aZRxxgt7",
                "block_hash" => "FrWmh1BtBc8yvAZPJrJ97nVth6eryukbLANyFQ3TuQai",
                "sender" => "86e6ebcc723106eee951c344825b91a80b46f42ff8b1f4bd366f2ac72fab99d1",
                "receiver" => "d73888a2619c7761735f23c798536145dfa87f9306b5f21275eb4b1a7ba971b9",
                "gas_burnt" => "424555062500",
                "actions" => [{"data" => {"deposit" => "716669915088987500000000000"}, "type" => "Transfer"}],
                "actions_count" => 1,
                "success" => true}]
        allow(NearApi).to receive(:new).and_return(api)
        allow(api).to receive(:fetch_transactions).and_return(res)
        UpdateTransactions.new.perform
      end

      it 'does not duplicate BlockTransaction or Actions' do
        expect{ UpdateTransactions.new.perform }.to_not change {BlockTransaction.count}
      end
    end
  end
end