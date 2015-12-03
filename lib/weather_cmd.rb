require_relative "./weather_cmd/version"

require 'open_weather'
require 'pry'

module WeatherCmd
  $options = {
    units: "metric",
    APPID: ENV['OPEN_WEATHER_API_KEY']
  }

  def self.parse(user_input)
    @location = ''

    if user_input[0] != 'in'
      abort("Syntax must be: #{$0} in <City>, <State>")
    end

    user_input.each do |item|
      next if item.equal?("in")
      @location = @location + ' ' + item
    end

    begin
      current_weather = OpenWeather::Current.city(@location, $options)

      if current_weather["cod"].equal?("404")
        raise ArgumentException.new("Must be a valid City and State")
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
