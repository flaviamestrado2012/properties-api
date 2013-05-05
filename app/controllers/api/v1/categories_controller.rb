module Api
  module V1
    class CategoriesController < ApplicationController

      respond_to :json
      
      def index
        @categories = Category.all 

        respond_with( {
          :statusCode => 0,
          :statusMessage => "Success",
          :categories => @categories
          })
      end

      def show
        begin
          @category = Category.find(params[:id])

          respond_with( {
            :statusCode => 0,
            :statusMessage => "Success",
            :category => @category
          })

        rescue ActiveRecord::RecordNotFound
          respond_with( {
            :statusCode => 1,
            :statusMessage => "Failed to get category"
          })
        end
      end
      
    end
  end
end
