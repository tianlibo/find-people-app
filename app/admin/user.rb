ActiveAdmin.register User do

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
  permit_params :name, :email, :phone, :crumbs_count
  
  index do 
    column :id 
    column :name
    column :crumbs_count
    column :email
    column :phone
    actions
  end

  form do |f|
    f.inputs "users" do
      f.input :name
      f.input :email
      f.input :phone
      f.input :crumbs_count
    end
    f.actions
  end
end
