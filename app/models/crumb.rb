class Crumb < ActiveRecord::Base

  scope :unate, -> { where(ate: false) }
  #随机创建100个records
  def self.random_create_records(lng,lat)
    for i in 0..99
      Crumb.create(longitude:(lng+Random.rand(0.00599)),latitude:(lat+Random.rand(0.00599)),accuracy:Random.rand(100))
    end 
  end

  def self.all_lnglat
    Crumb.unate.map{|c| [c.longitude.to_f,c.latitude.to_f]}
  end

  def self.find_to_eat(lng,lat,user)
    @crumbs = Crumb.find_by_sql("SELECT * FROM crumbs WHERE ate = false AND earth_distance(ll_to_earth("+lat.to_s+","+lng.to_s+"), ll_to_earth(crumbs.latitude, crumbs.longitude)) < 5")
    user.update crumbs_count: user.crumbs_count + @crumbs.size
    @crumbs.each do |c|
      c.update ate: true
    end
  end
end
