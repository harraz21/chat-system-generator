class CreateChatConsumer < Racecar::Consumer
  subscribes_to "create_chat"
  

  def process(message)
    data = JSON.parse(message.value)
    puts data
  end
end
