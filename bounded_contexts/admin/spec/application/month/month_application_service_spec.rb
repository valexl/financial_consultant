require 'spec_helper'

RSpec.describe Admin::Application::Month::MonthApplicationService do
  let(:service) { described_class.new repository, producer }

  let(:repository) { Admin::Port::Adapter::Persistence::MemoryMonthRepository.new }
  let(:producer) { Admin::Port::Adapter::Messaging::Kafka::FakeAdminTopicProducer.new }

  describe "#call" do
    subject(:call) { service.call }

    it { is_expected.not_to raise_error }
  end
end