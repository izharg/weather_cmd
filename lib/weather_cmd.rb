require_relative "./weather_cmd/version"

require 'open_weather'
require 'pry'
require 'open-uri'
require 'csv'

module WeatherCmd
  OPEN_WEATHER_OPTIONS = {
    units: "metric",
    APPID: ENV['OPEN_WEATHER_API_KEY']
  }

  def self.parse(user_input)
    @location = ''

    openweather_city_list = 'http://openweathermap.org/help/city_list.txt'
    content = open(openweather_city_list).read
    city_list = Hash.new { |key, value| key[value] = Array.new }

    content.each_line do |line|
      if result = line.match(/\d+\t([a-zA-z ]+)\t[0-9.-]+\t[0-9.-]+\t(\w+)$/)
        city, state = result.captures
        city_list[state].push city
      end
    end

    if user_input.join(" ") !~ /^in\s/
      abort("Syntax must be: #{$0} in <City>, <State>")
    end

    if result = user_input.join(" ").match(/^in\s([a-zA-z\- ]+),\s(\w+)/)
      user_city, user_state = result.captures
    else
      abort("Syntax must be: #{$0} in <City>, <State>")
    end

    begin
      raise ArgumentError.new("Must be a valid City and State") unless city_list[user_state].include? user_city
      @location = user_city + ', ' + user_state
      current_weather = OpenWeather::Current.city(@location, OPEN_WEATHER_OPTIONS)

      if current_weather["cod"].equal?("404")
        raise ArgumentError.new("Must be a valid City and State")
      end
    rescue Exception => msg
      puts msg
      exit 1
    end

    @description = current_weather["weather"][0]["description"]
    @temperature = current_weather["main"]["temp"].round(1)

    puts "#{@temperature}C, #{@description}"

    return "#{@temperature}C, #{@description}"
  end
end