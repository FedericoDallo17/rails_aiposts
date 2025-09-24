Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  namespace :api do
    namespace :v1 do
      # Authentication routes
      post 'auth/signup', to: 'auth#signup'
      post 'auth/signin', to: 'auth#signin'
      post 'auth/signout', to: 'auth#signout'
      post 'auth/reset_password', to: 'auth#reset_password'
      put 'auth/change_email', to: 'auth#change_email'
      put 'auth/change_password', to: 'auth#change_password'
      delete 'auth/delete_account', to: 'auth#delete_account'
      
      # User routes
      resources :users, only: [:index, :show] do
        member do
          post :follow
          delete :unfollow
          get :followers
          get :following
        end
        collection do
          get :search
          get :liked_posts
          get :commented_posts
          get :mentioned_posts
          get :tagged_posts
          put :update_profile
          put :update_profile_picture
          put :update_cover_picture
        end
      end
      
      # Post routes
      resources :posts do
        resources :comments, only: [:index, :create, :show, :update, :destroy]
        resources :likes, only: [:index, :create, :destroy]
        collection do
          get :feed
          get :search
        end
      end
      
      # Notification routes
      resources :notifications, only: [:index, :show, :destroy] do
        member do
          put :mark_read
          put :mark_unread
        end
        collection do
          get :unread
          get :read
          put :mark_all_read
          get :count
        end
      end
    end
  end

  # Defines the root path route ("/")
  root "rails/health#show"
end
