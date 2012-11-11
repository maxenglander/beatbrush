Beatbrushtest::Application.routes.draw do
  root to: 'pages#home'

  get 'music/lyrics', to: 'music#lyrics'
  get 'music/search',  to: 'music#search'

  match "arts/demo"
  get   "arts/search"
end
