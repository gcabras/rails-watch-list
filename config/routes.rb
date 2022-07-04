Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pages#home'
  get 'dashboard', to: 'pages#dashboard'
  resources :lists, only: %i[index show new create] do
    resources :bookmarks, only: %i[new create] do
    end
  end

  delete 'bookmarks/:id', to: 'bookmarks#destroy', as: :bookmark_destroy
end
