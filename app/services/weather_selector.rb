# app/services/weather_selector.rb

class WeatherSelector
  def self.get_service_class(weather_service_name)
    "#{weather_service_name.titlecase.gsub(' ', '')}::WeatherAccess".constantize
  end
end