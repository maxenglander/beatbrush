Beatbrushtest::Application.routes.draw do
  root to: 'pages#home'
  match "arts/demo"
  get   "arts/search"
end
