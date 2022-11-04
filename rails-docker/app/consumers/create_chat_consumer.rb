class CreateChatConsumer < Racecar::Consumer
  subscribes_to "chat_create"

  def process_batch(messages)
    chats = []
    sql = "INSERT INTO chats VALUES "
    sql_values = []
    messages.each do |message|
      data = JSON.parse(message.value)
        puts data["token"]
        puts data["chat_number"]
        app = Application.find_by(token: data["token"])
        chat_number = data["chat_number"]
        chat = Chat.create(number: chat_number, application: app, message_count: 0)
        #sql_values << "(#{chat.attributes.values.join(", ")})"
    end
    #sql += sql_values.join(", ")
    #ActiveRecord::Base.connection.insert_sql(sql)
  end
end