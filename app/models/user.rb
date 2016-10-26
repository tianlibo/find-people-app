class User < ActiveRecord::Base
  
  has_many :positions

  def self.find_to_eat(lng,lat,user)
    #sql 在添加的时间判断后，优化的效果并不是很明显
    #WITH CTE_positions AS (SELECT * FROM positions WHERE latitude BETWEEN 39.9740546 AND 39.9750546 AND longitude BETWEEN 116.3011849 AND 116.3021849 ) SELECT users.* FROM CTE_positions,users WHERE users.id = CTE_positions.user_id AND earth_distance(ll_to_earth(39.97455424,116.3016434),ll_to_earth(latitude,longitude)) < 5 AND CTE_positions.created_at > (now() - interval '1 minutes' * 5);
    #@users = User.find_by_sql("SELECT users.* FROM users,positions WHERE positions.user_id = users.id AND earth_distance(ll_to_earth("+lat.to_s+","+lng.to_s+"), ll_to_earth(positions.latitude, positions.longitude)) < 5 AND positions.created_at > (now() - interval '1 minutes' * 5)").uniq - [user]
    @users = User.find_by_sql("WITH CTE_positions AS (SELECT * FROM positions WHERE latitude BETWEEN "+(lat - 0.0005).to_s + " AND " + (lat + 0.0005).to_s + " AND longitude BETWEEN " + (lng - 0.0005).to_s + " AND " + (lng + 0.0005).to_s + " AND positions.created_at > (now() - interval '1 minutes' * 1)) SELECT users.* FROM CTE_positions,users WHERE users.id = CTE_positions.user_id AND earth_distance(ll_to_earth("+lat.to_s+","+lng.to_s+"),ll_to_earth(latitude,longitude)) < 10 AND crumbs_count < " + user.crumbs_count.to_s ).uniq
    @users.each do |another_user|
      if another_user.crumbs_count < user.crumbs_count 
        user.update crumbs_count: (user.crumbs_count + another_user.crumbs_count)
        another_user.update crumbs_count: 0
      end
    end
  end
end
