class Map
  class << self
    def redis_map_update(new_lng,new_lat,key)
      @object = redis.hgetall(key)
      old_lng = regex.match(@object["longitude"]).to_s
      old_lat = regex.match(@object["latitude"]).to_s
      lng = regex.match(new_lng).to_s
      lat = regex.match(new_lat).to_s

      if old_lng == lng && old_lat == lat
        return
      else
        redis.sadd(redis_key(lng,lat),key)
        redis.srem(redis_key(old_lng,old_lat),key)
      end
    end

    #这个函数完成后需要好好测一下,用两个集合做交集运算  
    def redis_map_info(lng,lat)
      #这个循环感觉时间复杂度有点高
      origin_lng = regex.match(lng).to_s
      origin_lat = regex.match(lat).to_s
      @crumbs = []
      @players = []
      location = []
      for i in -1..1
        tmp_lng = BigDecimal.new(origin_lng) + BigDecimal.new("0.0001")*i
        for j in -1..1
          tmp_lat = BigDecimal.new(origin_lat) + BigDecimal.new("0.0001")*j
          location << [tmp_lng.to_s,tmp_lat.to_s]
        end
      end

      location.each do |loc|
        keys = redis.smembers(redis_key(loc[0],loc[1]))
        keys.each do |key|
          if key.include?("crumbs")
            @crumbs  << redis.hgetall(key)
          else 
            @players << redis.hgetall(key)
          end
        end
      end

      return @players,@crumbs
    end

    #需要测试，float精度会损耗
    def redis_map_distance(loc1,loc2)
      rad_per_deg = Math::PI/180  # PI / 180
      rkm = 6371                  # Earth radius in kilometers
      rm = rkm * 1000             # Radius in meters

      dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
      dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

      lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
      lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

      a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
      c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

      rm * c # Delta in meters
    end

    private

    def redis
      $redis 
    end

    def redis_key(lng,lat)
      lat+"/"+lng
    end

    def regex
      /\d+.\d{4}/
    end
  end
end