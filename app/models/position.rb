class Position < ActiveRecord::Base

  belongs_to :user

  def self.all_people_newest_positions
    Position.find_by_sql("SELECT DISTINCT ON (user_id) * FROM positions ORDER BY user_id,id DESC")
  end
end
