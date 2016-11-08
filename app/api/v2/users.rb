module V2
  class Users < Grape::API
    version 'v2', using: :path
    format :json

    helpers V2::Helpers

    resource :users do 

      desc 'create a new user'

      params do 
        requires :name, type: String
      end

      post :create do 
        @user = User.new  name: params[:name]
        if @user.save
          { code: 0, data: {id: @user.id,  name: @user.name}}
        else
          { code: 1, info: @user.errors.messages}
        end
      end 

      desc 'get all users'
      get '/' do 
        @users = User.all
        {users:@users.as_json}
      end 
    end
  end
end