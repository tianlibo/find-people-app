module V1 
  class Users < Grape::API
    version 'v1', using: :path
    format :json


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
    end
  end
end