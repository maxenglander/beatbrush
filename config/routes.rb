Beatbrushtest::Application.routes.draw do
  root to: 'pages#home'

  get 'lyrics/search', to: 'lyrics#search'
end
