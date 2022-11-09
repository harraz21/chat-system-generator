module Api
    module V1
      class MessagesController < ApplicationController
        require "delivery_boy"
        include KeyBuilder
        include KafkaMessageBuilder
        require "kafka_topics"

        def index
          token = params[:application_token]
          chat_number = params[:chat_number]
          chat_key = KeyBuilder.build_chat_key(token, chat_number)
          messages = Message.where(chat_key: chat_key)
          if messages.any?
            render(json: messages.to_json(except: [:id, :chat_id]), status: :ok)
          else
            render(json: {message: "bad request application token , chat number or messages doesn't exist"}, status: 404)
          end
        end

        def show
          token = params[:application_token]
          chat_number = params[:chat_number]
          message_number = params[:number]
          chat_key = KeyBuilder.build_chat_key(token, chat_number)
          message = Message.find_by(chat_key: chat_key, number: message_number)
          puts message.message_text
          if message != nil
            render(json: message.to_json(except: [:id, :chat_id]), status: :ok)
          else
            render(json: {message: "bad request application token , chat number or message doesn't exist"}, status: 404)
          end
        end

        def create
          token = params[:application_token]
          chat_number = params[:chat_number]
          chat_key = KeyBuilder.build_chat_key(token, chat_number)
          if $redis.exists(chat_key)
              message_number = $redis.incr(chat_key)
              new_message =  params[:message]
              message = KafkaMessageBuilder.build_message_create_message(token, chat_number, message_number, new_message, 0)
              DeliveryBoy.deliver_async(message.to_json() , topic: KafkaTopics::CREATE_MESSAGE)
              render(json: {message_number: message_number}, status: :ok)
          else
              render(json: {message: "bad request application token or chat number doesn't exist"}, status: 404)
          end
      end

      def update
        token = params[:application_token]
        chat_number = params[:chat_number]
        message_number = params[:number]
        chat_key = KeyBuilder.build_chat_key(token, chat_number)
        message_count = $redis.get(chat_key)
        if message_count != nil && message_count >= message_number
          new_message = params[:message]
          message = KafkaMessageBuilder.build_message_update_message(chat_key, message_number, new_message, 0)
          DeliveryBoy.deliver_async(message.to_json() , topic: "update")
        else
          render(json: {message: "bad request application token , chat number or message doesn't exist"}, status: 404)
        end
      end

      def destroy
        token = params[:application_token]
        chat_number = params[:chat_number]
        message_number = params[:number]
        chat_key = KeyBuilder.build_chat_key(token, chat_number)
        message_count = $redis.get(chat_key)
        if message_count != nil && message_count >= message_number
          message = KafkaMessageBuilder.build_message_delete_message(token, chat_number, message_number, 0)
          DeliveryBoy.deliver_async(message.to_json() , topic: KafkaTopics::DELETE)
        else
          render(json: {message: "bad request application token , chat number or message doesn't exist"}, status: 404)
        end
      end

    end
  end
end