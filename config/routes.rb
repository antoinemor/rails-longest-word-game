Rails.application.routes.draw do
  get '/game', to: 'word_grids#game'

  get '/score', to: 'word_grids#score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

