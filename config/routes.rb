Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  
  mount V1::Users => '/api'
  mount V1::Positions => '/api'
end
