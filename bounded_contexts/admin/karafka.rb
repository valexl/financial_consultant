require_relative "./app"

class KarafkaApp < Karafka::App
  config.kafka.seed_brokers = %w[kafka://127.0.0.1:9092]
  config.client_id = 'fc_admin'
  
  consumer_groups.draw do
    # TODO: add something like that 
    # topic :spending_trackers do
    #   consumer Port::Adapter::Messaging::Kafka::Consumers::SpendingTrackersConsumer
    # end
  end
end