class CreateMessageConsumer < Racecar::Consumer
  require "delivery_boy"
  require "kafka_topics"
  include KafkaMessageBuilder
  include KeyBuilder
  subscribes_to KafkaTopics::CREATE_MESSAGE

  def process(message)
    data = JSON.parse(message.value)
    Chat.transaction do
      chat_number = data["chat_number"]
      token = data["token"]
      chat_key = KeyBuilder.build_chat_key(token, chat_number)
      chat = Chat.lock.find_by(chat_key: chat_key)
      if chat != nil
        message_number = data["message_number"]
        new_message = data["new_message"]
        chat.message_count += 1
        Message.create(number: message_number, chat_key: chat_key, message_text: new_message, chat: chat)
        chat.save
      elsif data["number_of_tries"] < 9
        data["number_of_tries"] += 1
        DeliveryBoy.deliver_async(data.to_json(), topic: KafkaTopics::CREATE_MESSAGE)
      end
    end
  end
end
