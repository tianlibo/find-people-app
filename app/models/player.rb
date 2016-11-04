class Player < ActiveRecord::Base
  belongs_to :user

  class << self
    #redis methods
    def redis_create(id,*arge)
      redis.mapped_hmset(redis_key(id),*arge)
      redis.sadd("players",redis_key(id))
    end

    def redis_update(id,*arge)
      redis.mapped_hmset(redis_key(id),*arge)
    end

    def redis_destroy(id)
      redis.del(redis_key(id))
      redis.srem("players",redis_key(id))
    end

    def redis_all
      keys = redis.smembers("players")
      @players = []
      keys.each do |key|
        @players << redis.hgetall(key)
      end
      return @players
    end

    def redis_find(id)
      redis.hgetall(redis_key(id))
    end


    def redis_key(id)
      "players:#{id}"
    end


    def eat(player,player_ids,crumb_ids)
      players_ate = []
      player_ids.each do |id|
        p = Player.redis_find(id)
        distance = Map.distance([player["latitude"].to_f,player["longitude"].to_f],[p["latitude"].to_f,p["longitude"].to_f])
        if distance < 5 && player["crumbs_count"].to_i > p["crumbs_count"].to_i
          Player.redis_update(player["id"],{crumbs_count:(player["crumbs_count"].to_i + p["crumbs_count"].to_i)})
          Player.redis_update(id,{crumbs_count: 0})
          players_ate << id
        end
      end

      crumbs_ate = []
      crumb_ids.each do |id|
        c = Crumb.redis_find(id)
        distance = Map.distance([player["latitude"].to_f,player["longitude"].to_f],[c["latitude"].to_f,c["longitude"].to_f])
        if distance < 5
          Player.redis_update(player["id"],{crumbs_count:(player["crumbs_count"].to_i + 1)})
          Crumb.redis_destroy(id)
          crumbs_ate << id
        end
      end

      return {players:players_ate,crumbs:crumbs_ate}
    end

    private

    def redis
      $redis 
    end
  end

  #postgres mothods
  class << self 
    def all_players_info
      Player.all.map{|p|[[p.longitude.to_f,p.latitude.to_f],[p.name.to_s,p.crumbs_count,p.created_at.to_s]]}

    end

    def find_to_eat(lng,lat,player)
      @players = Player.find_by_sql("WITH CTE_players AS (SELECT * FROM players WHERE latitude BETWEEN "+(lat - 0.0005).to_s + " AND " + (lat + 0.0005).to_s + " AND longitude BETWEEN " + (lng - 0.0005).to_s + " AND " + (lng + 0.0005).to_s + " ) SELECT * FROM CTE_players WHERE earth_distance(ll_to_earth("+lat.to_s+","+lng.to_s+"),ll_to_earth(latitude,longitude)) < 10 AND crumbs_count < " + player.crumbs_count.to_s + " AND crumbs_count > 1")
      @players.each do |another_player|
        player.update crumbs_count: (player.crumbs_count + another_player.crumbs_count)
        another_player.update crumbs_count: 0
      end
    end
  end
end
