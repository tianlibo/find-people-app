module V2
  class Crumbs < Grape::API
    version 'v2', using: :path
    format :json
 
    helpers V2::Helpers

    resource :crumbs do
      desc 'get all new crumbs'

      get '/' do 
        @crumbs = Crumb.redis_all.as_json()
      end

      params do 
        requires :crumb, type: Hash do
          requires :latitude
          requires :longitude
        end
      end

      desc 'create a new crumbs'
      post :create do 
        @crumb = Crumb.new params[:crumb].as_json
        if @crumb.save
          Crumb.redis_create(@crumb.id,@crumb.as_json(only:[:id,:latitude,:longitude]))
          {code: 0, info: ""}
        else
          {code: 1, info: @user.errors.messages}
        end
      end
    end
  end
end