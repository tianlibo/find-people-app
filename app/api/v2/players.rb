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
        old_player = Player.redis_find(params[:id])
        if Player.redis_update params[:id], latitude:params[:player][:latitude],longitude:params[:player][:longitude],accuracy:params[:player][:accuracy]
          #更新地图
          Map.redis_map_update(new_lng,new_lat,old_player)
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
        requires :players, type:Array
        requires :crumbs, type:Array
        requires :latitude
        requires :longitude
        requires :accuracy
      end

      #这个接口和put接口的分工有什么区别吗？
      post ':id/eat' do 
        Player.redis_update(params[:id],{longitude:params[:longitude],latitude:params[:latitude]})
        @player = Player.redis_find(params[:id])
        @objects = Player.eat(@player,params[:players],params[:crumbs])
        @player = Player.redis_find(params[:id])
        {code: 0, info: "", crumbs: @objects[:crumbs], crumbs_count: @player["crumbs_count"], players: @objects[:players]}
      end

      get '/' do 
        #获取当前所有玩家最新的位置信息
        #@players = Player.all.as_json()
        @players = Player.redis_all.as_json()
      end
    end
  end
end
