class UpdateDatabaseCountsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    apps = []
    chats = []
    apps_tokens = $redis.spop("apps_tokens")
    apps = Application.where(token: apps_tokens)
    apps.each do |app|
      app.chat_count = $redis.get(app.token)
    end
    chats_keys = $redis.spop("chats_keys")
    chats = Chat.where(chat_key: chats_keys)
    chats.each do |chat|
      chat.message_count = $redis.get(chat.chat_key)
    end
    Application.update_all(apps)
    Chat.update_all(chats)
  end
end
