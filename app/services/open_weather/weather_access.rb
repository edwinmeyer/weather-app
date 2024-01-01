# frozen_string_literal: true

module OpenWeather
  class WeatherAccess
    def initialize(api_key)
      @api_key = api_key
    end

    def get_weather(zipcode, lat, lon)
      if zipcode.present?
        lat_lon_name_country = zipcode_to_lat_lon(zipcode)
        lat = lat_lon_name_country[:lat]
        lon = lat_lon_name_country[:lon]
        raw_weather = get_weather_raw(lat, lon)
     else
        raw_weather = get_weather_raw(lat, lon)
      end

      if raw_weather[:cod].present?
        raise "The Open Weather service returned \"#{raw_weather[:message]}\" " \
          "The returned HTTP status was #{raw_weather[:cod]}."
      end

      converted_weather = {
        cached: raw_weather[:cached],
        lat:,
        lon:,
        timezone: raw_weather[:timezone],
        epoch_time: raw_weather[:current][:dt],
        date_time: Time.at(raw_weather[:current][:dt]).to_s,
        weather_brief: raw_weather[:current][:weather][0][:main],
        weather_desc: raw_weather[:current][:weather][0][:description],
        temp_c: (raw_weather[:current][:temp] - 273.15).round(1),
        temp_f: ((raw_weather[:current][:temp] - 273.15) * 9 / 5 + 32).round(1)
      }

      if lat_lon_name_country.present?
        converted_weather.merge!({
          name: lat_lon_name_country[:name],
          country: lat_lon_name_country[:country],
          zipcode: zipcode
        })
      end
      converted_weather
    end

    private

    def get_weather_raw(lat, lon)
      url = "https://api.openweathermap.org/data/3.0/onecall?lat=#{lat}&lon=#{lon}8&exclude=daily,alerts&appid=#{@api_key}"
      cached = true # Set initial "result retrieved from cache" value
      cache_key = "#{lat}_#{lon}"
      weather = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
        cached = false # We just got it, so it's not cached
        response = Faraday.get(url, { 'Accept' => 'application/json' })
        JSON.parse(response.body, symbolize_names: true)
      end
      weather[:cached] = cached # Add the cached value to the response
      weather
    end

    def zipcode_to_lat_lon(zipcode)
      raise "Invalid zipcode provided: #{zipcode}" unless zipcode =~ /\A\d{5}\Z/ # valid zipcode is a 5-digit string
      zip_us = "#{zipcode},US"
      url = "http://api.openweathermap.org/geo/1.0/zip?zip=#{zip_us}&appid=#{@api_key}"
      response = Faraday.get(url, { 'Accept' => 'application/json' })
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
