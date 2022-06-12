require_relative "./app"

class KarafkaApp < Karafka::App
  config.kafka.seed_brokers = %w[kafka://127.0.0.1:9092]
  config.client_id = 'fc_spendings_tracker'
  
  consumer_groups.draw do
    topic :admin do
      consumer Port::Adapter::Messaging::Kafka::KafkaMonthStartedListener
    end
  end
end