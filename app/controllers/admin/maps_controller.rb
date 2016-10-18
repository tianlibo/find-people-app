class Admin::MapsController < Admin::ApplicationController

  def index
    @positions = Position.all_people_newest_positions.collect{|position|[position.longitude.to_f,position.latitude.to_f]}
  end
end