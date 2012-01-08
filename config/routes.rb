Navd::Application.routes.draw do
  resource :dashboard, :only => [:show] do
    get :menu, :on => :member
  end
  root :to => "dashboards#show"
  match 'technoexperts' => 'pages#technoexperts'

  resources :notes, :only => [:index,:show]
  resources :memes, :only => [:index,:show] do
    resources :notes, :only => [:index,:show]
    collection do
      get :stats
      get :top
    end
    get :stat, :on => :member
  end
  resources :shows, :only => [:index,:show] do
    resources :notes, :only => [:index,:show]
    resources :memes, :only => [:index,:show]
    resources :videos, :only => [:index]
    get :mediawidget, :on => :member
    get :stat, :on => :member
  end
  resources :videos, :only => [:index]
end
