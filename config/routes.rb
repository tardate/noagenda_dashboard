Navd::Application.routes.draw do
  resource :dashboard
  root :to => "dashboard#show"

  # TODO need to refine/refactor:
  resources :notes
  resources :memes
  resources :shows
end
