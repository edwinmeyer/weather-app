Rails.application.routes.draw do

  resource :get_weather, only: [:show]

  # Defines the root path route ("/")
  root "get_weathers#show", zipcode: '95014', lat: '', lon: '' # Cupertino, CA
end
