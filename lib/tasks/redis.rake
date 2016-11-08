namespace :redis do
  desc "TODO restore redis  from postgres"
  task restore: :environment do
    Player.all.each do |p|
      Player.redis_create(p.id,p.as_json(only:[:id,:name,:crumbs_count,:latitude,:longitude]))
      Map.redis_map_create(p.longitude.to_s,p.latitude.to_s,Player.redis_key(p.id))
    end

    Crumb.all.each do |c|
      Crumb.redis_create(c.id,c.as_json(only:[:id,:latitude,:longitude]))
      Map.redis_map_create(c.longitude.to_s,c.latitude.to_s,Crumb.redis_key(c.id))
    end

    puts "END.."
  end
end

# rake redis:create:crumbs[11.1,123.2]
namespace :redis do 
  desc "TODO create data"
  namespace :create do 
    task :crumbs,[:lng, :lat] => :environment  do |t, args|
      Crumb.redis_random_create_records(args[:lng],args[:lat])
    end
    
    puts "END.."
  end
end