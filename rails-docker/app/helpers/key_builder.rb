module KeyBuilder

    def self.build_chat_key(token, chat_number)
        chat_key = "#{token}_#{chat_number}"
    end

    def self.build_message_key(token, chat_number, message_number)
        message_key = "#{token}_#{chat_number}_#{message_number}"
    end

    def self.build_message_key_from_chat_key(chat_key, message_number)
        message_key = "#{chat_key}_#{message_number}"
    end
end