Rails.application.routes.draw do
  get 'dashboards/index'
   devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  }


  devise_scope :user do
    authenticated :user do
      root to: 'dashboards#index', as: :authenticated_root
    end

    unauthenticated do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  root 'organizations#index'

  resources :dashboards, only: [:index]

  resources :organizations do
    member do
      patch :activate
      get :search_and_invite
    end
      post :create_invite, on: :member
  end
  resources :channels
  resources :videos, only: [:index]  
  resources :organization_invitations, only: [:index, :create]
  get '/accept_invite/:token', to: 'organization_invitations#accept', as: :accept_organization_invite
  get '/dashboard', to: 'users#dashboard', as: :user_dashboard

  get '/my_invitations', to: 'organization_invitations#index', as: :my_invitations
  post '/confirm_invite/:token', to: 'organization_invitations#confirm', as: :confirm_organization_invite
  get  '/organization_invites/signup', to: 'organization_invitations#signup', as: :organization_invite_signup
  post '/organization_invites/signup', to: 'organization_invitations#create_user_from_invite'
end