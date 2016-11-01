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
      redis.smembers("players")
    end

    def redis_find(id)
      redis.hgetall(redis_key(id))
    end

    private

    def redis
      $redis 
    end

    def redis_key(id)
      "players:#{id}"
    end
  end
end
