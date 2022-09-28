# spec/service/weather_selector_spec.rb

require 'rails_helper'

RSpec.describe WeatherSelector, type: :model do
  describe 'get_service_class(' do
    # let(:sender) { create(:user) }
    # let!(:sender_account) { create(:account, balance: 1_000, user: sender) }

    # let(:receiver) { create(:user) }
    # let!(:receiver_account) { create(:account, balance: 0, user: receiver) }

    it 'converts a service name into its class' do
      klass = WeatherSelector.get_service_class('open weather')
      expect(klass).to eq(OpenWeather::WeatherAccess)
    end
  end
end