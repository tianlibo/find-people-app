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
          { code: 0, info: ""}
        else
          { code: 1, info: @user.errors.messages}
        end
      end
       



      get :allPeoplePositions do 
        #获取当前所有人最新的位置信息
        @positions = Position.all_people_newest_positions()
        {positions: @positions.as_json}
      end

    end
  end
end