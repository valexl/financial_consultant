require 'spec_helper'

RSpec.describe Port::Adapter::Persistence::PGMonthRepository do
  let(:repository) { described_class.new  }

  before do
    DB[:months].delete
  end

  describe '#all_months' do
    subject(:all_months) { repository.all_months }

    let(:expected_entity) do
      Proc.new do |uniq_value, year, month_number|
        Domain::Model::Month::Month.new(
          id: identity.call(uniq_value),
          year: year,
          month_number: month_number
        )
      end
    end
    let(:identity) do
      created_at = Common::Domain::Model::CreatedAt.new(
        time: Time.at(Time.now .to_r)
      )

      Proc.new do |uniq_value|
        identity = Common::Domain::Model::Identity.new(
          subdomain: "admin",
          uniq_value: uniq_value.to_s,
          created_at: created_at
        )
      end
    end


    context "when there is no records" do
      it { is_expected.to eq([]) }
    end

    context "when there is 1 record" do
      

      before do
        DB[:months].insert(id: identity.call(123).to_s, year: 2022, month_number: 1)
      end

      it do
        is_expected.to contain_exactly(
          expected_entity.call(123, 2022, 1)
        )
      end
    end

    context "when there are 3 records" do
      before do
        DB[:months].insert(id: identity.call(123).to_s, year: 2022, month_number: 1)
        DB[:months].insert(id: identity.call(456).to_s, year: 2022, month_number: 2)
        DB[:months].insert(id: identity.call(789).to_s, year: 2022, month_number: 3)
      end

      it do
        is_expected.to contain_exactly(
          expected_entity.call(123, 2022, 1),
          expected_entity.call(456, 2022, 2),
          expected_entity.call(789, 2022, 3),
        )
      end

      context "and one of record was removed" do
        before do
          DB[:months].where(id: identity.call(123).to_s).delete
        end

        it do
          is_expected.to contain_exactly(
            expected_entity.call(456, 2022, 2),
            expected_entity.call(789, 2022, 3),
          )
        end

      end
    end

  end

  describe '#create' do
    subject(:create) { repository.create(month) }

    let(:month) do
      Domain::Model::Month::Month.new(
        id: identity,
        year: year,
        month_number: month_number
      )
    end
    let(:identity) do
      Common::Domain::Model::Identity.new subdomain: 'admin', uniq_value: '1234'
    end
    let(:year) { 2022 }
    let(:month_number) { 5 }

    it "adds a new record to DB" do
      expect { 
        create 
      }.to change {
        DB[:months].count
      }.from(0).to(1)
    end
  end
end
