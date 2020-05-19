Rails.application.routes.draw do
  resources :saml, only: :index do
    collection do
      get :sso
      post :acs
      get :metadata
      match :logout, via: %i[get post]
    end
  end

  root to: 'saml#index'
end
