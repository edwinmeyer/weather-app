# app/services/open_weather/weather_access.rb

class OpenWeather::WeatherAccess
  def initialize(api_key)
    @api_key = api_key
  end

  # Pyongyang lat=39.0392&lon=125.7625
  # ADD USE CACHE INDICATOR
  def get_weather_raw(lat, lon)
    url = "https://api.openweathermap.org/data/3.0/onecall?lat=#{lat}&lon=#{lon}8&exclude=daily,alerts&appid=#{@api_key}"
    cache_key = "#{lat}_#{lon}"
    weather = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      puts "Url not previously cached"
      response = Faraday.get(url, {'Accept' => 'application/json'})
      JSON.parse(response.body, symbolize_names: true) # [:current]
    end
  end

  def get_weather(lat, lon)
    raw_weather = get_weather_raw(lat, lon)
    converted_weather = {
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
