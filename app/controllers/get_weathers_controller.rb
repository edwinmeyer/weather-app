class GetWeathersController < ApplicationController
  def show
    zipcode = params[:zipcode]
    lat = params[:lat]
    lon = params[:lon]
    service = params[:service] || 'Open Weather'
    weather_service_class = WeatherSelector.get_service_class(service)
    api_key = ENV['OPEN_WEATHER_API_KEY'] # TODO: fix if multiple services are ever implemented
    weather_service = weather_service_class.new(api_key)
    @weather_info = weather_service.get_weather(zipcode.strip, lat.strip, lon.strip)
  rescue RuntimeError => e
    @weather_info ||= {}
    @weather_info[:runtime_error] = e.message
  end
end
