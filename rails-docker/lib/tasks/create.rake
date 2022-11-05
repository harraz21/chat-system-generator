# bin/rake create:import
desc 'create rake task'
task :setcount => :environment do
        apps_tokens = []
        chats_keys = []
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
        Rails.logger.info "count is set" 
end
