module Api
    module V1
      class ChatsController < ApplicationController
  
        def index
          Chats.all
        end
  
        def update
        end
        
        # GET /user/1
        # GET /user/1.json
        # def show
        #   @chatapplications = ChatApplication.find(params[:id])
  
        #   render json: @chatapplications
        # end
  
        def update
        end
  
        def create
            number = $redis.incr(params[:application_token])
            $redis.set(params[:application_token] + '_' + "#{number}", 0)
            require "delivery_boy"
            message = { :token => params[:application_token], :chat_number => number}
            DeliveryBoy.deliver_async message.to_json , topic: "chat_create"
            $redis.sadd("apps_tokens", params[:application_token])
            render json: number
        end
      end
    end
  end