Rails.application.routes.draw do

  get '/get_weather', to: 'get_weather#show'

  # Defines the root path route ("/")
  root "get_weather#show", zipcode: '95014', lat: '', lon: '' # Cupertino, CA
end
