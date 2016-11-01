module V2
  class Players < Grape::API
    version 'v2', using: :path
    format :json
 
    helpers V2::Helpers

    resource :players do

      desc 'create player'

      params do 
        requires :player, type: Hash do 
          requires :name, type:String
          requires :user_id, type:Integer
          requires :latitude
          requires :longitude
          requires :accuracy
        end
      end

      post :create do 
        @player = Player.new  name:params[:player][:name],user_id:params[:player][:user_id],latitude:params[:player][:latitude],longitude:params[:player][:longitude],accuracy:params[:player][:accuracy]
        if @player.save
          Player.redis_create(@player.id,@player.as_json(only:[:id,:name,:crumbs_count,:latitude,:longitude]))
          {code: 0, info: ""}
        else
          {code: 1, info: @user.errors.messages}
        end
      end

      desc 'update player by id'
 
      params do 
        requires :player, type: Hash do
          requires :latitude
          requires :longitude
          requires :accuracy
        end
      end

      put ':id' do 
        if Player.redis_update params[:id], latitude:params[:player][:latitude],longitude:params[:player][:longitude],accuracy:params[:player][:accuracy]
          #update 后更新玩家位置坐标


          {code: 0, info: ""}
        else
          {code: 1, info: @user.errors.messages}
        end
        # if @player.update  latitude:params[:player][:latitude],longitude:params[:player][:longitude],accuracy:params[:player][:accuracy]
          
        #   @players = []
        #   @ate = false

        #   if @player.crumbs_count > 1 
        #     @players = Player.find_to_eat(@player.longitude.to_f,@player.latitude.to_f,@player)
        #   end
          
        #   if @player.crumbs_count == 0
        #     @ate = true
        #     @player.update crumbs_count: 1
        #   end

        #   @crumbs = Crumb.find_to_eat(@player.longitude.to_f,@player.latitude.to_f,@player)

        #   {code: 0, info: "", crumbs: @crumbs.map{|c|c.id}.as_json, crumbs_count: @player.crumbs_count, ate: @ate, players: @players.map{|p|p.name}.as_json}
        # else
        #   {code: 1, info: @user.errors.messages}
        # end
      end

      params do 
        requires :eat_type, type:String
        requires :eat_id, type:Integer
        requires :latitude
        requires :longitude
        requires :accuracy
      end

      Post :eat do 
        #计算两点之间的距离，完成吃或不吃
        #更新位置
        #返回结果
      end

      get '/' do 
        #获取当前所有玩家最新的位置信息
        #@players = Player.all.as_json()
        @players = Player.redis_all.as_json()
      end
    end
  end
end
