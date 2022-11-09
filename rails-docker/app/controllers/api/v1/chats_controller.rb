module Api
  module V1
    class ChatsController < ApplicationController
      require "delivery_boy"
      include ElasticsearchUtils
      include KeyBuilder
      include KafkaMessageBuilder
      require "kafka_topics"
      
      require "response_message_builder"
        
  
      ## 
      def index
        token = params[:application_token]
        application = Application.find_by(token: token)
        if application != nil
          chats = Chat.where(application_id: application.id)
          render(json: chats.to_json(except: [:id, :application_id]), status: :ok)
        else
          render(json: {message: "bad request application token or chat number doesn't exist"}, status: 404)
        end
      end

      def show
        token = params[:application_token]
        number = params[:number]
        chat_key = KeyBuilder.build_chat_key(token, number)
        chat = Chat.find_by(chat_key: chat_key)
        if chat != nil
          render(json: chat.to_json(include: {
            :messages => {except: [:id, :chat_id]}
            }, 
            except: [:id, :application_id]), 
            status: :ok)
          else
            render(json: {message: "bad request application token or chat number doesn't exist"}, status: 404)
          end
        end

        def create
          token = params[:application_token]
          if $redis.exists(token)
            number = $redis.incr(token)
            chat_key = KeyBuilder.build_chat_key(token, number)
            $redis.set(chat_key, 0)
            message = KafkaMessageBuilder.build_message_create_chat(token, number)
            DeliveryBoy.deliver_async(message.to_json , topic: KafkaTopics::CREATE_CHAT)
            render(json: {chat_number: number}, status: :ok)
          else
            render(json: {message: "bad request token doesn't exist"}, status: 404)
          end
        end

        def destroy
          token = params[:application_token]
          number = params[:number]
          chat_key = KeyBuilder.build_chat_key(token, number)
          if $redis.exists(chat_key)
            message = KafkaMessageBuilder.build_message_delete_chat(chat_key, 0)
            DeliveryBoy.deliver_async(message.to_json , topic: KafkaTopics::DELETE)
            render(json: {message: "deleting chat", chat_number: number}, status: :ok)
          else
            render(json: {message: "bad request application token or chat number doesn't exist"}, status: 404)
          end
        end

        def search
          token = params[:application_token]
          chat_number = params[:chat_number]
          chat_key = KeyBuilder.build_chat_key(token, chat_number)
          if $redis.exists(chat_key)
            results = Message.search_partial(params[:search_query], chat_key)
            messages = ElasticsearchUtils.extract_chats_result(results)
            render(json: messages, status: :ok)
          else
            render(json: {message: "bad request application token or chat number doesn't exist"}, status: 404)
          end
        end

      end
    end
end