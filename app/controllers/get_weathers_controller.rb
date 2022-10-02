class GetWeathersController < ApplicationController
  def show
    lat = params[:lat]
    lon = params[:lon]
    service = params[:service] || "Open Weather"
    weather_service_class = WeatherSelector.get_service_class(service)
    # TODO Move api_key to a service-specific ENV variable
    api_key = 'cc8c0d018f89d57a9e1d137db7c1f362'
    weather_service = weather_service_class.new(api_key)
    @weather_info = weather_service.get_weather(lat, lon)
  end

  def edit
  end

  def update
  end
end
