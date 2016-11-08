module V2
  class Maps < Grape::API
    version 'v2', using: :path
    format :json

    helpers V2::Helpers

    resource :maps do 

      desc 'get players near area'

      desc 'get all users'
      params do 
        requires :longitude, type: String
        requires :latitude, type: String
      end
      get :near do 
        @objects = Map.redis_map_info(params[:longitude,:latitude])
        {players:@objects[:players].as_json,crumbs:@objects[:crumbs].as_json}
      end 
    end
  end
end