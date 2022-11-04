

# bin/rake create:import
namespace :create do
    task :import => :environment do
        require "kafka"
        kafka = Kafka.new(["kafka:9092"])
        consumer = kafka.consumer(group_id: "my-group")
        consumer.subscribe("create_chat")
        consumer.each_message do |message|
            puts "#{message.topic}, #{message.partition}, #{message.offset}, #{message.key}, #{message.value}"
        end
    end
end
