require 'spec_helper'

RSpec.describe Domain::Model::Month::Month do
  subject(:month) { described_class.new id: "admin_1234", year: 2022, month_number: 5 }

  describe "#id" do
    subject(:id) { month.id }

    it { is_expected.to eq "admin_1234" }
  end

  describe "#year" do
    subject(:year) { month.year }

    it { is_expected.to eq 2022 }
  end

  describe "#month_number" do
    subject(:month_number) { month.month_number }
    
    it { is_expected.to eq 5 }
  end
end
