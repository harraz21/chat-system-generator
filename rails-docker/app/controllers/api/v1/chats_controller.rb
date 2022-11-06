module Api
    module V1
      class ChatsController < ApplicationController
  
        def index
          Chats.all
        end

        def show
          key = "#{params[:application_token]}_#{params[:number]}"
          chat = Chat.find_by(chat_key: key)
          render json: chat.to_json(include: {:messages => {except: [:id, :chat_id]}}, except: [:id, :application_id])
        end

        def create
            number = $redis.incr(params[:application_token])
            $redis.set(params[:application_token] + '_' + "#{number}", 0)
            require "delivery_boy"
            message = { :token => params[:application_token], :chat_number => number}
            DeliveryBoy.deliver_async message.to_json , topic: "chat_create"
            render json: number
        end

        def search
          key = "#{params[:application_token]}_#{params[:chat_number]}"
          results = MessageBody.search_partial(params[:search_query], key)
          msgs = []
          results.first(10).each do |res|
            msgs.append(res["_source"]["message_text"])
          end
          render json: msgs
        end

      end
    end
  end