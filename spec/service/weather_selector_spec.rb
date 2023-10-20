# spec/service/weather_selector_spec.rb

require 'rails_helper'

RSpec.describe WeatherSelector, type: :model do
  describe 'get_service_class(' do
    it 'converts a service name into its class' do
      klass = WeatherSelector.get_service_class('open weather')
      expect(klass).to eq(OpenWeather::WeatherAccess)
    end
  end
end
