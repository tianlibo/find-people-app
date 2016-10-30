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

      params do 
        requires :crumb, type: Hash do
          requires :latitude
          requires :longitude
        end
      end

      desc 'create a new crumbs'
      post :create do 
        @crumb = Crumb.new latitude:params[:crumb][:latitude], longitude:params[:crumb][:longitude]
        if @crumb.save
          {code: 0, info: ""}
        else
          {code: 1, info: @user.errors.messages}
        end
      end
    end
  end
end