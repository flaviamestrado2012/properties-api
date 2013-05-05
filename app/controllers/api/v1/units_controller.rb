module Api
  module V1
    class UnitsController < ApplicationController

      respond_to :json

      def index
        @units = Unit.all

        render :json => { 
          :statusCode => 0, 
          :statusMessage => 'Sucess', 
          :units => @units
        }
         
      end
      
      def show
        begin
          @unit = Unit.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          respond_with( {
            :statusCode => 1,
            :statusMessage => "Failed to get unit"
          })
        end
      end    
        
    end
  end
end