module Api
  module V1
    class ApplicationsController < ApplicationController
      require "delivery_boy"
      include KafkaMessageBuilder
      require "kafka_topics"
      require "response_message_builder"
      

      def index
        render(json: Application.all().to_json(except: :id))
      end

      def show 
        token = params[:token]
        application = Application.find_by(token: token)
        if application != nil
          render(json: application.to_json(except: :id))
        else
          render(json: {message: "application not found"}, status: 404)
        end
      end

      def create
        name = params[:name]
        application = Application.new()
        application.name = name
        application.save!()
        render(json: application.to_json(except: :id))
      end

      def update
        token = params[:token]
        application = Application.find_by(token: token)
        if application != nil
          new_name = params[:name]
          application.name = new_name
          application.save!()
          render(json: application.to_json(except: :id))
        else
          render(json: {message: "application not found"}, status: 404)
        end
      end

      def destroy
        token = params[:token]
        if $redis.exists(token)
          message = KafkaMessageBuilder.build_message_delete_application(token, number_of_tries: 0)
          DeliveryBoy.deliver_async(message.to_json , topic: KafkaTopics::DELETE)
          render(json: {message: "deleting chat application", application_token: token}, status: :ok)
        else
          render(json: {message: "application not found"}, status: 404) 
        end
      end

    end
  end
end