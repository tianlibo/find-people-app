module V1 
  class Crumbs < Grape::API
    version 'v1', using: :path
    format :json
 
    helpers V1::Helpers

    resource :crumbs do
      desc 'get all new crumbs'

      get :index do 
        @crumbs = Crumb.unate
        {
          crumbs: @crumbs.collect{|c|
            { 
              id: c.id,
              latitude: c.latitude.to_f,
              longitude: c.longitude.to_f,
              accuracy: c.accuracy.to_f,
              created_at: c.created_at
            } 
          }
        }
      end
    end
  end
end