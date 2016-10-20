module V1 
  class Positions < Grape::API
    version 'v1', using: :path
    format :json
 
    helpers V1::Helpers

    resource :positions do
      desc 'create a new position'
 
      params do 
        requires :position, type: Hash do
          requires :user_id, type: Integer
          requires :latitude
          requires :longitude
          requires :accuracy
        end
      end

      post :create do 
        @position = Position.new user_id:params[:position][:user_id],latitude:params[:position][:latitude],longitude: params[:position][:longitude],accuracy: params[:position][:accuracy]
        if @position.save
          Crumb.find_to_eat(@position.longitude.to_f,@position.latitude.to_f) 
          {code: 0, info: ""}
        else
          {code: 1, info: @user.errors.messages}
        end
      end

      get :index do 
      #获取当前所有人最新的位置信息
      @positions = Position.all_people_newest_positions()
      {positions: @positions.collect{|position|
          { 
            id: position.id,
            user_id: position.user_id,
            latitude: position.latitude.to_f,
            longitude: position.longitude.to_f,
            accuracy: position.accuracy.to_f,
            created_at: position.created_at
          }
        }
      }
      end
    end
  end
end
