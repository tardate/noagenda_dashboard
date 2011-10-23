Navd::Application.routes.draw do
  resource :dashboard, :only => [:show] do
    get :menu, :on => :member
  end
  root :to => "dashboards#show"
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
    get :mediawidget, :on => :member
    get :stat, :on => :member
  end
end
