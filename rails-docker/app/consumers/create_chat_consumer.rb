class CreateChatConsumer < Racecar::Consumer
  subscribes_to "chat_create"

  def process(message)
    ActiveRecord::Base.transaction do
      chats = []
      data = JSON.parse(message.value)
      puts data
      new_messages = []
      Application.transaction do
        app = Application.lock.find_by(token: data["token"])
        chat_number = data["chat_number"]
        chat = Chat.create(number: chat_number, application: app, message_count: 0, chat_key: "#{data["token"]}_#{chat_number}")
        chat_key = "#{data["token"]}_#{data["chat_number"]}"
        new_messages = Message.lock.where(["chat_key = :chat_key and chat_id = :chat", { chat_key: chat_key, chat: nil }])
        new_messages.each do |new_message|
          new_message[:chat] = chat
        end
        app.chat_count += 1
        app.save
      end
      if(new_messages.any?)
        Message.update_all(new_messages)   
      end
    end      
  end
end


# class CreateChatConsumer < Racecar::Consumer
#   subscribes_to "chat_create"

#   def process_batch(payload)
#     chats = []
#     payload.each do |kafka_message|
#         data = JSON.parse(kafka_message.value)
#         puts data
#         app = Application.find_by(token: data["token"])
#         chat_number = data["chat_number"]
#         chat = Chat.create(number: chat_number, application: app, message_count: 0, chat_key: "#{data["token"]}_#{chat_number}")
#         chat_key = "#{data["token"]}_#{data["chat_number"]}"
#         messages = Message.where(["chat_key = :chat_key and chat_id = :chat", { chat_key: chat_key, chat: nil }])
#         messages.each do |message|
#           message[:chat] = chat
#         end
#         Message.update_all(messages)
#         #sql_values << "(#{chat.attributes.values.join(", ")})"
#     end
#     #sql += sql_values.join(", ")
#     #ActiveRecord::Base.connection.insert_sql(sql)
#   end
# end