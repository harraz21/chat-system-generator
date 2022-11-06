class CreateMessageConsumer < Racecar::Consumer
  require "delivery_boy"
  subscribes_to "message_create"

  def process(message)
    ActiveRecord::Base.transaction do
      data = JSON.parse(message.value)
      chat = Chat.lock.where(number: data["chat_number"]).joins(:application).where("applications.token = '#{data["token"]}'").first
      message_number = data["message_number"]
      message_chat_key = "#{data["token"]}_#{data["chat_number"]}"
      Message.create(number: message_number, chat_key: message_chat_key, chat: chat)
      ####
      MessageBody.create(message_key: "#{message_chat_key}", message_text: data["message_body"])
      chat.message_count += 1
      chat.save
    end
  end
end
