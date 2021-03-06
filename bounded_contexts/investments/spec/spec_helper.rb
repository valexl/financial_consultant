require 'rake'
load 'Rakefile'
Rake::Task['create_test_db'].invoke
Rake::Task['db_migrate_test'].execute

ENV['RACK_ENV'] = 'test'
require 'rspec-roda'
require 'byebug'

require_relative '../app'
require_relative 'support/rspec_matchers'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
