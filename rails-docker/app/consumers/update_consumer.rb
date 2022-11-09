class UpdateConsumer < Racecar::Consumer
  require "delivery_boy"
  require "entities"
  include KafkaMessageBuilder
  include KeyBuilder
  subscribes_to KafkaTopics::UPDATE


  def process(message) 
    data = JSON.parse(message.value)
    handle_messages(data)
  end

  def handle_messages(data)
    message = Message.find_by(chat_key: data["chat_key"], number: data["message_number"])
    if message != nil
      message.message_text = data["new_message"]
      message.save!
    elsif data["number_of_tries"] <= 9
      data["number_of_tries"] += 1
      DeliveryBoy.deliver_async(data, topic: KafkaTopics::UPDATE)
    end
  end

end
