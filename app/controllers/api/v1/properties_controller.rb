module Api
  module V1
    class PropertiesController < ApplicationController
      
      respond_to :json

      def index
        @properties = Property.all   
        
        render :json => { 
          :statusCode => 0, 
          :statusMessage => 'Sucess', 
          :properties => @properties.as_json(:include => { :unit => { :except  => [:id, :created_at, :updated_at] } })
        }
        
      end
      
      def show
        begin
          @property = Property.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          respond_with( {
            :statusCode => 1,
            :statusMessage => "Failed to get property"
          })
        end
      end   
       
    end
  end
end