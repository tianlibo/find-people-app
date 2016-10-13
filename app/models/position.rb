class Position < ActiveRecord::Base

  belongs_to :user

  def self.all_people_newest_positions
    Position.select("DISTINCT ON(user_id) *")
  end
end
