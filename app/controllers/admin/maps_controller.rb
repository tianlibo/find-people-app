class Admin::MapsController < Admin::ApplicationController

  def index
    #@positions = Position.all_people_newest_positions.collect{|position|[position.longitude.to_f,position.latitude.to_f]}
    #@positions = Position.all_newest_latlong
    if params[:id].blank? 
      @positions = Position.all_position_info
      @crumbs = Crumb.all_lnglat
    else  
      p = Position.where(user_id: params[:id]).includes(:user).last
      @positions = [[[p.longitude.to_f,p.latitude.to_f],[p.user.name.to_s,p.user.crumbs_count,p.created_at.to_s]]]
      @crumbs = []
    end
    @center = @positions[0][0]
  end
end