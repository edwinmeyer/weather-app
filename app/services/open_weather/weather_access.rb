# app/services/open_weather/weather_access.rb

class OpenWeather::WeatherAccess
  def initialize(api_key)
    @api_key = api_key
  end

  def get_weather_raw(lat, lon)
    url = "https://api.openweathermap.org/data/3.0/onecall?lat=#{lat}&lon=#{lon}8&exclude=daily,alerts&appid=#{@api_key}"
    cached = true # Set initial "result retrived from cache" value
    cache_key = "#{lat}_#{lon}"
    weather = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      cached = false # We just got it, so it's not cached
      response = Faraday.get(url, {'Accept' => 'application/json'})
      JSON.parse(response.body, symbolize_names: true)
     end
    weather[:cached] = cached # Add the cached value to the response
    weather
  end

  def get_weather(lat, lon)
    raw_weather = get_weather_raw(lat, lon)
    converted_weather = {
      cached: raw_weather[:cached],
      lat: lat,
      lon: lon,
      timezone: raw_weather[:timezone],
      epoch_time: raw_weather[:current][:dt],
      date_time: Time.at(raw_weather[:current][:dt]).to_s,
      weather_brief: raw_weather[:current][:weather][0][:main],
      weather_desc: raw_weather[:current][:weather][0][:description],
      temp_c: (raw_weather[:current][:temp]-273.15).round(1),
      temp_f: ((raw_weather[:current][:temp]-273.15) *9/5+32).round(1)
    }
  end
end
