class Position < ActiveRecord::Base

  belongs_to :user

  def self.all_people_newest_positions
    Position.find_by_sql("SELECT DISTINCT ON (user_id) * FROM positions ORDER BY user_id,id DESC")
  end

  def self.all_newest_latlong
    Position.find_by_sql("SELECT DISTINCT ON (user_id) latitude, longitude FROM positions ORDER BY user_id,id DESC").map{|p| [p.longitude.to_f,p.latitude.to_f]}
  end

  def self.find_to_eat(lng,lat)
    Position.find_by_sql("SELECT * FROM positions WHERE earth_distance(ll_to_earth("+lat.to_s+","+lng.to_s+"), ll_to_earth(positions.latitude, positions.longitude)) < 1")
  end
end
