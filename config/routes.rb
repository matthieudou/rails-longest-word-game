Rails.application.routes.draw do
  get 'game', to: 'word#game', as: 'game'

  get 'score', to: 'word#score', as: 'score'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
