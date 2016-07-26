Rails.application.routes.draw do
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks' }

  post '/twitter/disconnect' =>'profiles#twitter_disconnect', as: :twitter_disconnect
  post '/soundcloud/disconnect' =>'profiles#soundcloud_disconnect', as: :soundcloud_disconnect
  post '/paypal/remove_confirmation' =>'profiles#paypal_remove_confirmation', as: :paypal_remove_confirmation
  get '/paypal/confirmation/:profile_id' =>'profiles#paypal_confirmation', as: :paypal_confirmation, constraints: { profile_id: /[\d]+/ }
  post '/paypal/confirm' =>'profiles#paypal_confirm', as: :paypal_confirm
  get '/soundcloud' => 'profiles#soundcloud'
  get '/soundcloud_request' => 'profiles#soundcloud_request', as: :profiles_soundcloud_request
  get '/musician/sign_up' => 'home#new_musician', as: :new_musician_registration
  get '/visitor/sign_up'  => 'home#new_visitor' , as: :new_visitor_registrations
  post '/visitor_try_book/sign_up'  => 'home#new_visitor_try_book' , as: :new_visitor_try_book_registrations
  post '/visitor_try_book/sign_in'  => 'home#old_visitor_try_book' , as: :old_visitor_try_book_registrations
  get '/profiles/new' => 'profiles#new' , as: :new_profile
  post '/profiles/create' => 'profiles#create' , as: :create_profile
  get '/profiles' => 'profiles#show', as: :view_profile
  post '/profile/rate' => 'reviews#rate_profile' , as: :rate_a_profile
  post '/profile/comment' => 'reviews#comment_profile' , as: :comment_a_profile

  post '/youtube/disconnect' =>'profiles#youtube_disconnect', as: :youtube_disconnect
  get  '/facebook_page/lists' => 'profiles#facebook_page', as: :facebook_page
  post '/facebook_page/connect' => 'profiles#facebook_page_connect', as: :facebook_page_connect
  post  '/facebook/disconnect' => 'profiles#facebook_disconnect', as: :facebook_disconnect
  get '/profiles/list' => 'profiles#users_profiles_list' , as: :profiles_users_profiles_list
  get '/profiles/facebook_friend_page' => 'profiles#facebook_friend_page', as: :facebook_friend_page
  post '/facebook_friend_page/connect' => 'profiles#facebook_friend_page_connect', as: :facebook_friend_page_connect
  get "profiles/facebook_one" => 'profiles#facebook_one', :as => :facebook_one
  get "profiles/facebook_two" => 'profiles#facebook_two', :as => :facebook_two
  get "profiles/twitter_one" => 'profiles#twitter_one', :as => :twitter_one
  get "profiles/twitter_two" => 'profiles#twitter_two', :as => :twitter_two
  post '/profiles/invite_friend' => 'profiles#invite_friend'
  post '/profiles/crop' => 'profiles#crop', :as => :crop
  post '/profiles/invite_twitter_friend' => 'profiles#invite_twitter_friend'
  post "/profiles/user_email_change" => 'profiles#user_email_change', :as => :user_email_change
  get "/facebook_disconnect_friend" => "profiles#facebook_disconnect_friend", :as => :facebook_disconnect_friend
  get "/twitter_disconnect_friend" => "profiles#twitter_disconnect_friend", :as => :twitter_disconnect_friend 
  #patch "/profiles/profile_save_params" => "profiles#profile_save_params", :as => :profile_save_params
  constraints(id: /[0-9]+/) do
    resources :profiles, only: [:show, :edit, :update, :destroy] do
      get :choose_profile
      get :delete_profile
      get :profile_type, on: :collection
    end
  end
  get '/profile/:slug' => 'profiles#show_slug', as: :profile_slug, constraints: { slug: /[a-z|\d|\-]+/ } 

  resources :services, only: [:create, :new, :show, :index, :edit]
  post '/update/service' => 'services#update', as: :update_service

  resources :services, only: [:delete] do
    member do
      post :delete
    end
  end

  resources :jobs

  resources :conversations,
            only: [:index, :show],
            path: 'inbox', param: :id do
    get 'admin', on: :member
  end
  resources :reviews, only: [:create]
  resources :reviews , only: [:delete] do
    member do
      post :delete
    end
  end
  post '/modal/submit_request' => 'booking_requests#modal_submit'

  post '/booking_request/special_offer/:id',
       to: 'booking_requests#special_offer',
       as: :special_offer
  post '/booking_request/create_special_offer',
       to: 'booking_requests#special_offer',
       as: :create_special_offer
  post '/booking_requests/:service_id',
       to: 'booking_requests#create',
       as: :booking_requests
  post '/create_booking_requests',
       to: 'booking_requests#create',
       as: :booking_requests_modal
  get '/booking_request/new/:service_id',
      to: 'booking_requests#new',
      as: :new_booking_request
  get '/booking_requests',
      to: 'booking_requests#index',
      as: :booking_list
  post '/accept_request/:booking_request_id',
       to: 'booking_requests#accept_request',
       as: :accept_request
  post '/cancel_request/:booking_request_id',
       to: 'booking_requests#cancel_request',
       as: :cancel_request
  post '/cancel_booking/:booking_request_id',
       to: 'booking_requests#cancel_booking',
       as: :cancel_booking
  post '/reject_request/:booking_request_id',
       to: 'booking_requests#reject_request',
       as: :reject_request
  get '/my_booking',
      to: 'booking_requests#my_booking',
      as: :list_my_booking

  get '/booking_request',
      to: 'booking_requests#booking_request',
      as: :list_request_booking

  post '/subscribe',
       to: 'newsletters#subscribe',
       as: :newsletter_subscription

  get '/booking_request/:id',
      to: 'booking_requests#show'

  devise_scope :user do
    get '/users/edit/payment_method',
        to: 'users/registrations#payment_method',
        as: :account_payment_method
    put '/users/edit/payment_method',
        to: 'users/registrations#payment_method_update',
        as: :payment_method_update
    get '/users/edit/receiving_money',
        to: 'users/registrations#receiving_money',
        as: :account_receiving_money
    put '/users/edit/receiving_money',
        to: 'users/registrations#receiving_money_update',
        as: :receiving_money_update

    put '/users/edit/payment_token',
        to: 'users/registrations#store_payment_token',
        as: :store_payment_token

    get '/settings/login', to: 'users/registrations#edit', as: :edit_user_login
    get '/settings/notifications', to: 'users/registrations#notifications', as: :notifications
    put '/settings/notifications', to: 'users/registrations#set_notifications', as: :set_notifications
    get '/settings/user_profile', to: 'users/registrations#user_profile', as: :user_profile
    put '/settings/user_profile', to: 'users/registrations#update_user_profile', as: :update_user_profile
    get '/settings/delete_account', to: 'users/registrations#delete_account', as: :delete_account
  end

  post '/messages/:id', to: 'messages#create', as: :messages
  post '/messages', to: 'messages#create', as: :create_message
  get '/message/new/:id', to: 'messages#new', as: :new_message
  post '/messages/:id/admin',
       to: 'messages#message_for_admin',
       as: :messages_to_admin

  post 'admin/user/:id/edit',
       to: 'admins/base#send_reset_password_instruction',
       as: :send_reset_password_instruction

  get '/dashboard', to: 'dashboards#summary', as: :dashboard_summary

  post '/', to: 'home#preferred_currency', as: :preferred_currency
  get 'how_it_works'          => 'home#how_it_works'
  get 'privacy_policy'        => 'home#privacy_policy'
  get 'terms_and_conditions'  => 'home#terms_and_conditions'
  get 'faq'                   => 'home#faq'
  get 'cancellation_policies' => 'home#cancellation_policies'
  get 'about'                 => 'home#about'
  get 'become_a_partner'      => 'home#become_a_partner'
  post'become_a_partner'      => 'home#submit_become_a_partner', as: :submit_become_a_partner
  get 'browse_musicians'      => 'home#browse_musicians'
  post'browse_musicians'      => 'home#browse_musicians', as: :nearby_musicians
  post'search_musicians'      => 'home#search_musicians'
  get 'contact'               => 'home#contact'
  post'contact'               => 'home#submit_contact_us', as: :submit_contact_us
  get 'help'                  => 'home#help'
  get '/twitter_home'         => 'home#twitter_home', as: :twitter_home
  get '/facebook_home'        => 'home#facebook_home', as: :facebook_home
  root 'home#index'
end
