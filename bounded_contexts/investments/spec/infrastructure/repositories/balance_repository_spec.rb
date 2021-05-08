require 'spec_helper'

RSpec.describe Repositories::BalanceRepository do
  let(:db) { }
  
  describe ".initiate" do
    subject(:initiate) { described_class.initiate }

    it "creates new record in db" do
      expect { initiate }.to change { DB[:balances].count }.by(1)
    end
  end

  describe ".fetch" do
    subject(:fetch) { described_class.fetch(money_creator) }

    let(:money_creator) { MoneyCreator.new(builder) } 
    let(:builder) { }

    it { is_expected.to be_a(Balance) }
  end
end