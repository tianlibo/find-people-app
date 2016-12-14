module V1 
  class Players < Grape::API
    version 'v1', using: :path
    format :json
 
    helpers V1::Helpers

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
          {code: 0, info: ""}
        else
          {code: 1, info: @user.errors.messages}
        end
      end

      desc 'update player by id'
 
      # params do 
      #   requires :player, type: Hash do
      #     requires :latitude
      #     requires :longitude
      #     requires :accuracy
      #   end
      # end

      put ':id' do
        @player = Player.find_by_id(params[:id])
        if @player.update  latitude:params[:player][:latitude],longitude:params[:player][:longitude],accuracy:params[:player][:accuracy]
          @players = []
          @ate = false

          if @player.crumbs_count > 1 
            @players = Player.find_to_eat(@player.longitude.to_f,@player.latitude.to_f,@player)
          end
          
          if @player.crumbs_count == 0
            @ate = true
            @player.update crumbs_count: 1
          end

          @crumbs = Crumb.find_to_eat(@player.longitude.to_f,@player.latitude.to_f,@player)

          {code: 0, info: "", crumbs: @crumbs.map{|c|c.id}.as_json, crumbs_count: @player.crumbs_count, ate: @ate, players: @players.map{|p|p.name}.as_json}
        else
          {code: 1, info: @user.errors.messages}
        end
      end

      desc 'get player by id'


      get ':id' do 
        @player = Player.find_by_id(params[:id])

        if @player 
          {code: 0, info: "", player: @player.as_json}
        else 
          {code: 1, info: "player no exist"}
        end
      end

      get '/' do 
        #获取当前所有玩家最新的位置信息
        @players = Player.all.as_json()
      end
    end
  end
end
