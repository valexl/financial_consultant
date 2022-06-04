require 'spec_helper'

RSpec.describe SpendingsTracker::Application::Month::MonthApplicationService do
  subject(:service) { described_class.new(repository: repository) }

  let(:repository) { SpendingsTracker::Port::Adapter::Persistence::MemoryMonthRepository.new } # TODO: add repository once have one

  describe '#start_month' do
    subject(:start_month) { service.start_month(command) }

    let(:command) do
      SpendingsTracker::Application::Month::StartMonthCommand.new(
        id: 'admin-1234-1653808886.01657',
        year: 2022,
        month_number: 5
      )
    end

    it 'creates a new month' do
      expect { start_month }.to change { repository.all_months.count }.by(1)
    end
  end
end
