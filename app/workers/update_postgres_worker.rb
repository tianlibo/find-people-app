class UpdatePostgresWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    #删除crumbs
    puts "START"
    crumbs_ids = []
    players = {}
    keys = redis.smembers("crumbs:destroy")
    keys.each do |k|
      crumbs_ids << k.split(':')[1].to_i
      redis.srem("crumbs:destroy",k)
    end
    Crumb.where(id: crumbs_ids).delete_all
    
    #更新player
    keys = redis.smembers("players")
    keys.each do |k|
      players.store(k.split(':')[1].to_i,redis.hgetall(k))
    end
    Player.update(players.keys, players.values)

    puts "END.."
  end

  private 

  def redis
    $redis
  end
end