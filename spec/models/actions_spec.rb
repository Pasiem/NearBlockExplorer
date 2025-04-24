require 'spec_helper'

RSpec.describe Action, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:block_transaction).inverse_of(:actions) }
  end

  describe 'validations' do
    subject { create(:action) }

    it { is_expected.to validate_presence_of(:action_type) }
    it { is_expected.to validate_presence_of(:data) }
  end
end