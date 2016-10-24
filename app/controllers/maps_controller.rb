class MapsController < ApplicationController
  
  def index
    @positions = Position.all_position_info
    @crumbs = Crumb.all_lnglat
  end
end