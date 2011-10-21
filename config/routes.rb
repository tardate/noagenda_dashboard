Navd::Application.routes.draw do
  resource :dashboard, :only => [:show]
  root :to => "dashboard#show"
  match 'technoexperts' => 'pages#technoexperts'

  resources :notes, :only => [:index,:show]
  resources :memes, :only => [:index,:show] do
    resources :notes, :only => [:index,:show]
    get :stats, :on => :collection
    get :stat, :on => :member
  end
  resources :shows, :only => [:index,:show] do
    resources :notes, :only => [:index,:show]
    resources :memes, :only => [:index,:show]
  end
end
