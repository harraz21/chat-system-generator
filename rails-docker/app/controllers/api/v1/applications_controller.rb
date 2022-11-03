module Api
  module V1
    class ApplicationsController < ApplicationController

      def index
        render json: Application.all
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
        name = params[:name]
        application = Application.new
        application.name = name
        application.save
        
        render json: application.slice('name', 'token', 'chat_count')
      end
    end
  end
end