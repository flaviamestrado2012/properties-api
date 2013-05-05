module Api
  module V1
    class ProfilesController < ApplicationController

      respond_to :json

      def index
        @profiles = Profile.all
        
        render :json => { 
          :statusCode => 0, 
          :statusMessage => 'Sucess', 
          :profiles => @profiles.as_json(:include => { :property_ranges => { :include => [:property], :except  => [:profile_id, :created_at, :updated_at] } }) 
        }

      end
      
      def show
        begin
          @profile = Profile.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          respond_with( {
            :statusCode => 1,
            :statusMessage => "Failed to get profile"
          })
        end
      end    
        
    end
  end
end
