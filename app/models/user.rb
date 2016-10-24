class User < ActiveRecord::Base
  
  has_many :positions

  def self.find_to_eat(lng,lat,user)
    @users = User.find_by_sql("SELECT users.* FROM users,positions WHERE positions.user_id = users.id AND earth_distance(ll_to_earth("+lat.to_s+","+lng.to_s+"), ll_to_earth(positions.latitude, positions.longitude)) < 5 AND positions.created_at > (now() - interval '1 minutes' * 5)").uniq - [user]
    @users.each do |another_user|
      if another_user.crumbs_count < user.crumbs_count 
        user.update crumbs_count: (user.crumbs_count + another_user.crumbs_count)
        another_user.update crumbs_count: 0
      end
    end
  end
end
