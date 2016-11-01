class Admin::MapsController < Admin::ApplicationController

  def index
    #@positions = Position.all_people_newest_positions.collect{|position|[position.longitude.to_f,position.latitude.to_f]}
    #@positions = Position.all_newest_latlong
    if params[:id].blank? 
      @players = Player.all_players_info
      @crumbs = Crumb.all_lnglat
    else  
      p = Player.find(id)
      @players = [[[p.longitude.to_f,p.latitude.to_f],[p.user.name.to_s,p.user.crumbs_count,p.created_at.to_s]]]
      @crumbs = []
    end
    @center = @players.size > 0 ? @players[0][0] : [116.43416079,39.96593914]
  end
end