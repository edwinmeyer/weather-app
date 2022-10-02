Rails.application.routes.draw do

  resource :get_weather, only: [:show]

   # Defines the root path route ("/")
  root "get_weathers#show", lat: 41.8781, lon: -87.6298 # Chicago, IL
end
