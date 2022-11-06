module Api
  module V1
    class ApplicationsController < ApplicationController
      
      def index
        render json: Application.all.to_json(except: :id)
      end

      def show # 
        render json: application.find_by!()
      end

      def update
        application = Application.find_by(token: params[:token])
        application.name = params[:name]
        application.save()
        render json: "2y 7aga"
      end

      def create
        name = params[:name]
        application = Application.new
        application.name = name
        application.save()
        render json: application.slice('name', 'token', 'chat_count')
      end
    end
  end
end