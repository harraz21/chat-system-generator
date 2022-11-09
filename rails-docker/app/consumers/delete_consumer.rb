class DeleteConsumer < Racecar::Consumer
  require "delivery_boy"
  require "entities"
  include KafkaMessageBuilder
  include KeyBuilder
  subscribes_to KafkaTopics::DELETE

  def process(message)
    data = JSON.parse(message.value)
    if data["entity"] == Entity::APPLICATION
      handle_applications(data)
    elsif data["entity"] == Entity::CHAT
      handle_chats(data)
    elsif data["entity"] == Entity::MESSAGE
      handle_messages(data)
    end
  end

  def handle_messages(data)
    token = data["token"]
    chat_number = data["chat_number"]
    message_number = data["message_number"]
    chat_key = KeyBuilder.build_chat_key(token, chat_number)
    message = Message.find_by(chat_key: chat_key, number: message_number)
    if message != nil
      message.destroy
    elsif data["number_of_tries"] <= 9
      data["number_of_tries"] += 1
      DeliveryBoy.deliver_async(data, topic: KafkaTopics::DELETE)
    end
  end

  def handle_chats(data)
    chat_key = data["chat_key"]
    chat = Chat.find_by(chat_key: chat_key)
    if chat != nil
      chat.destroy
    elsif data["number_of_tries"] <= 9
      data["number_of_tries"] += 1
      DeliveryBoy.deliver_async(data, topic: KafkaTopics::DELETE)
    end
  end

  def handle_applications(data)
    application = Application.find_by!(token: data["token"])
    if application != nil
      application.destroy
    end
  end

end
