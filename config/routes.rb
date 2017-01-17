Rails.application.routes.draw do
  resources :resume
  root 'welcome#index'
end
