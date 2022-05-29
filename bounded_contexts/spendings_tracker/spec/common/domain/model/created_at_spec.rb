require 'spec_helper'

RSpec.describe Common::Domain::Model::CreatedAt do
  let(:created_at) { described_class.new time: time_value }

  let(:time_value) { Time.now }


  describe "#to_s" do
    subject(:to_s) { created_at.to_s }

    it { is_expected.to eq("#{time_value.to_f}")}
  end

  describe "#time" do
    subject(:time) { created_at.time }

    it { is_expected.to eq(time_value) }

    context "when there is no given created_at" do
      let(:created_at) { described_class.new }

      it { expect(time.to_i).to eq(Time.now.to_i ) }
    end
  end
end
