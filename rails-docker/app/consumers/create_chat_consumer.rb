class CreateChatConsumer < Racecar::Consumer
  include KeyBuilder
  require "kafka_topics"
  subscribes_to KafkaTopics::CREATE_CHAT

  def process(message)
    ActiveRecord::Base.transaction do
      data = JSON.parse(message.value)
      new_messages = []
      Application.transaction do
        token = data["token"]
        application = Application.lock.find_by(token: token)
        if application != nil
          chat_number = data["chat_number"]
          chat_key = KeyBuilder.build_chat_key(token, chat_number)
          chat = Chat.new(number: chat_number, application: application, message_count: 0, chat_key: chat_key)
          Message.transaction do
            new_messages = Message.lock.where(["chat_key = :chat_key", {chat_key: chat_key}])
            new_messages.each do |new_message|
              new_message[:chat] = chat
              chat.message_count += 1
            end
          end
          chat.save
          application.chat_count += 1
          application.save
        end
      end
      if(new_messages.any?)
        Message.update_all(new_messages)   
      end
    end      
  end
end