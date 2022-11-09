module KafkaMessageBuilder
    require 'entities'

    def self.build_message_create_chat(token, chat_number)
        message = { token: token, chat_number: chat_number}
    end

    def self.build_message_create_message(token, chat_number, message_number, new_message, number_of_tries)
        message = { token:  token, chat_number: chat_number,
            message_number: message_number, new_message: new_message, number_of_tries: number_of_tries}
    end

    def self.build_message_delete_application(token, number_of_tries)
        message = { entity: Entity::APPLICATION, token: token, number_of_tries: number_of_tries}
    end

    def self.build_message_delete_chat(chat_key, number_of_tries)
        message = { entity: Entity::CHAT, chat_key: chat_key, number_of_tries: number_of_tries}
    end

    def self.build_message_delete_message(token, chat_number, message_number, number_of_tries)
        message = { entity: Entity::MESSAGE, token: token, chat_number: chat_number, message_number: message_number, number_of_tries: number_of_tries}
    end

    def self.build_message_update_application(token, number_of_tries)
        message = { entity: Entity::APPLICATION, token: token, number_of_tries: number_of_tries}
    end

    def self.build_message_update_chat(chat_key, number_of_tries)
        message = { entity: Entity::CHAT, chat_key: chat_key, number_of_tries: number_of_tries}
    end

    def self.build_message_update_message(chat_key, message_number, new_message, number_of_tries)
        message = { entity: Entity::MESSAGE, chat_key: chat_key, message_number: message_number, new_message: new_message,number_of_tries: number_of_tries}
    end
end