ActiveAdmin.register Player do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  permit_params :id, :name, :user_id, :latitude, :longitude, :accuracy ,:crumbs_count

  index do 
    column :id 
    column :user_id
    column :name
    column :latitude
    column :longitude
    column :accuracy
    column :crumbs_count
    actions
  end

  form do |f|
    f.inputs "users" do
      f.input :user_id
      f.input :name
      f.input :crumbs_count
      f.input :latitude
      f.input :longitude
    end
    f.actions
  end
end
