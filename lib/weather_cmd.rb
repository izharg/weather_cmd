require_relative "./weather_cmd/version"

require 'open_weather'
require 'pry'

module WeatherCmd
  OPEN_WEATHER_OPTIONS = {
    units: "metric",
    APPID: ENV['OPEN_WEATHER_API_KEY']
  }

  def self.parse(user_input)
    puts user_input.inspect
  end
end
