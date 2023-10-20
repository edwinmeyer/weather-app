# README

## Introduction
'weather-app' is a demo Ruby on Rails application that reports the current weather for a U.S. locale, 
given either a latitude & longitude or a zipcode. It obtains data from two APIs available from 
openweathermap.org, which is created and maintained by London-based OpenWeather Ltd.    

One API returns voluminous weather data for a locale specified by latitude & longitude. The second API converts a
country's postal code to latitude & longitude values, 
which then are fed to the first API to obtain that locale's weather data. ('weather-app' accepts only U.S. zipcodes.)  
Selected values from the data returned by the APIs are sent to an EJB view for display to the user.

'weather-app' returns useful error messages if a provided zipcode isn't properly formatted (not five digits), or if 
the weather API returns an error.

## Setup & Usage
### Versions
'weather-app' was developed against ruby version 3.1.2p20 and rails version 7.0.4. It also should run on later 
versions.

### API Key
To run the app, a free API key (good for up to 1,000 requests per day) can be obtained from openweathermap.org.
The key needs to be exported as an environment variable in a console session before the app is started. The command is:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;export OPEN_WEATHER_API_KEY='api_key'   
where api_key is your own API key. Thereafter, 'rails s' can be issued to to the app in the same console session. 

### Usage
After the app starts enter 'localhost:3000'. Current weather data is presented for Cupertino, CA.
To obtain weather info from other locales, enter either latitude & longitude or a zipcode. Then click "Get Weather" at 
the bottom of the presented sky-blue panel.   
Note that the locale name will be returned only if a zipcode is entered; not for latitude & longitude entry.  

## Architecture Summary
One interesting aspect of the app is that it is structured to allow different vendors' APIs to be used to obtain
weather data, although it is still skeletal in nature and only the openweathermap.org APIs are implemented. Currently
hardwired as 'Open Weather', the view could have an input field to set the 'service' param to a different service.
This is implemented by having the GetWeathersController make a call to WeatherSelector.get_service_class with the
service name. It returns the class name of the proper service (here OpenWeather::WeatherAccess). The WeatherAccess
class implements the service functionality. For Open Weather, its pathname is
app/services/open_weather/weather_access.rb

Except for the fact there are no models and no database (the volatile cache is the only data store that preserves data 
across requests), 'weather-app' is fairly standard. A request to the get_weather endpoint is routed to
GetWeathersController, which calls WeatherSelector.get_service_class(service) to get the class name (here 
OpenWeather::WeatherAccess), instantiate it, then call its get_weather method with input coordinates and zipcode. 
get_weather does all the work, then returns output data to the controller. Then the controller invokes the ERB view.


## Testing
A quite sparse set of Rspec tests is available due to time constraints. Most of these tests are marked 'pending' due 
to errors. Given more time, the pending tests could be fixed, tests for an entered zipcode - both correct and 
malformed - as well as for erroneous entries could be added. End-to-end tests could also be added to make sure the 
view displays correctly.

## Screenshots
Screenshots of normal and error cases are stored in the public directory: burlington-vt-by-zipcode-uncached.png, 
burlington-vt-by-zipcode-cached.png, burlington-vt-by-coords-cached.png, invalid-zipcode.png, and 
longitude-in-atlantic-ocean.png   
Access them as e.g. http://localhost:3000/burlington-vt-by-coords-cached.png
## TODOs
The app has a few TODOs sprinkled though the code. Given enough time, these could be dealt with, as well as numerous 
other mostly minor issues. Perhaps the biggest deficiency is the semi-disconnect between search by coordinates and by 
zipcode. This resulted from the fact that search by coordinates was implemented first, and the search by zipcode was added 
later.