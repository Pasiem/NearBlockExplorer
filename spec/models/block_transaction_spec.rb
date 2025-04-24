require 'spec_helper'

RSpec.describe BlockTransaction, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:actions).inverse_of(:block_transaction) }
  end

  describe 'validations' do
    subject { create(:block_transaction) }

    it { is_expected.to validate_presence_of(:sender) }
    it { is_expected.to validate_presence_of(:receiver) }
    it { is_expected.to validate_presence_of(:trans_hash) }
    it { is_expected.to validate_uniqueness_of(:trans_hash) }

    context 'conditional validations' do
      let(:block_transaction) {
        build(:block_transaction, contains_transfer: true, transfer_deposit: nil)
      }
      it 'validates presence of transfer_deposit when contains_transfer is true' do
        block_transaction.valid?
        expect(block_transaction.errors.full_messages).to include("Transfer deposit can't be blank if Contains transfer")
      end
    end
  end

  describe 'scopes' do
    let!(:block_transaction) { create(:block_transaction) }
    let!(:invalid_block_transaction) { create(:block_transaction, success: false, contains_transfer: false) }

    describe '.contains_transfer' do
      it 'only returns block transactions with contains_transfer true' do
        expect(described_class.contains_transfer).to_not contain_exactly(invalid_block_transaction)
      end
    end

    describe '.successful' do
      it 'only returns block transactions with success true' do
        expect(described_class.contains_transfer).to_not contain_exactly(invalid_block_transaction)
      end
    end
  end
end