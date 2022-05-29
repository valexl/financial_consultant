require 'spec_helper'

RSpec.describe Application::Month::MonthApplicationService do
  subject(:service) { described_class.new(repository: repository) }

  let(:repository) { Test::Port::Adapter::Persistence::MemoryMonthRepository.new } # TODO: add repository once have one

  describe "#start_month" do
    subject(:start_month) { service.start_month(command) }

    let(:command) do 
      Application::Month::StartMonthCommand.new(
        id: "admin-1234-1653808886.01657",
        year: 2022,
        month_number: 5
      )
    end

    it "creates a new month" do
      expect { start_month }.to change { repository.all_months.count }.by(1)
    end
  end
end