module Api
    module V1
      class MessagesController < ApplicationController
        require "delivery_boy"

        def index
          Message.all # except to remove ids
        end
  
        def update
          # handle elastic search if not yet written to index
          # try again later
          # update_message : es_keys, and num of retries 9    // 
          return ok
        end

        def show
          message
        end
  

        def create
            chat_redis_key = "#{params[:application_token]}_#{params[:chat_number]}"
            messages_count = $redis.get(chat_redis_key)
            if $redis.exists(chat_redis_key) == 1
                number = $redis.incr(chat_redis_key)
                $redis.set("#{chat_redis_key}_#{number}", 0)
                # TODO create helpers to create kafka messages and redis keys
                message = { :token => params[:application_token], :chat_number => params[:chat_number], :message_number => number, :message_body => params[:msg]}
                DeliveryBoy.deliver_async message.to_json , topic: "message_create"
                $redis.sadd("chats_keys", chat_redis_key)
                render json: number
            else
                render json: "chat number or application token not found!", status: 400
            end
        end
      end
    end
  end