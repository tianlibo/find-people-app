class Crumb < ActiveRecord::Base
  scope :unate, -> { where(ate: false) }

  class << self
    #redis methods
    def redis_create(id,*arge)
      redis.mapped_hmset(redis_key(id),*arge)
      redis.sadd("crumbs",redis_key(id))
    end
  
    def redis_update(id,*arge)
      redis.mapped_hmset(redis_key(id),*arge)
    end

    def redis_destroy(id)
      redis.del(redis_key(id))
      redis.srem("crumbs",redis_key(id))
      redis.sadd("crumbs:destroy",redis_key(id))
    end

    def redis_all
      redis.smembers("crumbs")
      @crumbs = []
      keys.each do |key|
        @crumbs << redis.hgetall(key)
      end
      return @crumbs
    end

    def redis_find(id)
      redis.hgetall(redis_key(id))
    end
    
    # 此处有问题，没有更新map, 考虑是否把创建的工作放到rake中
    def redis_random_create_records(lng,lat)
      for i in 0..9
        @crumb = Crumb.create(longitude:(lng.to_f + Random.rand(0.00599)),latitude:(lat.to_f + Random.rand(0.00599)),accuracy:Random.rand(100).to_s)
        Crumb.redis_create(@crumb.id,{longitude:@crumb.longitude,latitude:@crumb.latitude,accuracy:@crumb.accuracy})
        Map.redis_map_create(@crumb.longitude.to_s,@crumb.latitude.to_s,Crumb.redis_key(@crumb.id))
      end
    end

    def redis_key(id)
      "crumb:#{id}"
    end

    private

    def redis
      $redis 
    end
  end

  #postgres mothods
  class << self 
    def random_create_records(lng,lat)
      for i in 0..99
        Crumb.create(longitude:(lng+Random.rand(0.00599)),latitude:(lat+Random.rand(0.00599)),accuracy:Random.rand(100))
      end 
    end

    def all_lnglat
      Crumb.unate.map{|c| [c.longitude.to_f,c.latitude.to_f]}
    end

    def find_to_eat(lng,lat,user)
      #@crumbs = Crumb.find_by_sql("SELECT * FROM crumbs WHERE ate = false AND earth_distance(ll_to_earth("+lat.to_s+","+lng.to_s+"), ll_to_earth(crumbs.latitude, crumbs.longitude)) < 5")
      @crumbs = Crumb.find_by_sql("WITH CTE_crumbs AS (SELECT * FROM crumbs WHERE latitude BETWEEN "+(lat - 0.0005).to_s + " AND " + (lat + 0.0005).to_s + " AND longitude BETWEEN " + (lng - 0.0005).to_s + " AND " + (lng + 0.0005).to_s + " AND ate = false) SELECT * FROM CTE_crumbs WHERE earth_distance(ll_to_earth("+lat.to_s+","+lng.to_s+"),ll_to_earth(latitude,longitude)) < 5")
      user.update crumbs_count: user.crumbs_count + @crumbs.size
      @crumbs.each do |c|
        c.update ate: true
      end
    end
  end
end
