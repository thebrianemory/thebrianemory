Rails.application.routes.draw do
  resources :resume
  get '/my_not_so_secret_homepage_for_new_tabs', to: 'new_tab#index'
  root 'welcome#index'
end
