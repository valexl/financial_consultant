require 'spec_helper'

RSpec.describe Port::Adapter::Messaging::Kafka::KafkaMonthStartedListener do
  subject(:listener) { described_class.new repository }

  let(:repository) { Port::Adapter::Persistence::MemoryMonthRepository.new }

  describe "#filtered_dispatch" do
    subject(:filtered_dispatch) { listener.filtered_dispatch(event_payload) }

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

    context "when event is admin.month.month_started" do
      let(:event_payload) do
        {
          "event" => "admin.month.month_started",
          "payload" => {
            "id" => identity.call(123).to_s,
            "year" => 1,
            "month_number" => 1
          }
        }
      end

      it "delegates logic to MonthApplicationService" do
        expect_any_instance_of(Application::Month::MonthApplicationService).to receive(:start_month)
        filtered_dispatch
      end
    end

    context "when event is not admin.month.month_started" do
      let(:event_payload) do
        {
          "event" => "admin.month.month_finished",
          "payload" => {
            "id" => identity.call(123).to_s,
            "year" => 1,
            "month_number" => 1
          }
        }
      end

      it "doesn't delegate logic to MonthApplicationService" do
        expect_any_instance_of(Application::Month::MonthApplicationService).not_to receive(:start_month)
        filtered_dispatch
      end
    end
  end
end