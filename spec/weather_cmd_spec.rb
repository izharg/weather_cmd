require_relative "../lib/weather_cmd"

RSpec.describe WeatherCmd do
  let(:open_weather_api_response) do
    {
      "coord"=> {"lon"=>34.8, "lat"=>32.08}, 
      "weather"=>[{"id"=>501, "main"=>"Rain", "description"=>"moderate rain", "icon"=>"10n"}], 
      "base"=>"cmc stations", 
      "main"=> {
        "temp"=>17.81, 
        "pressure"=>1021.32, 
        "humidity"=>100, 
        "temp_min"=>17.81, 
        "temp_max"=>17.81, 
        "sea_level"=>1030.02, 
        "grnd_level"=>1021.32
      }, 
      "wind"=>{"speed"=>3.72, "deg"=>75.0048}, 
      "rain"=>{"3h"=>3.4025}, 
      "clouds"=>{"all"=>92}, 
      "dt"=>1446837725, 
      "sys"=>{"message"=>0.0123, "country"=>"IL", "sunrise"=>1446782517, "sunset"=>1446821189}, 
      "id"=>293396, 
      "name"=>"Tel Aviv District", 
      "cod"=>200
    }
  end

  context ".parse" do
    context "Current weather in Tel-Aviv" do
      let(:user_input) { ["in", "Tel-Aviv,", "IL"] }

      before(:each) do
        allow(OpenWeather::Current).to receive(:city).and_return(open_weather_api_response)
      end

      it "should return a description of the current weather & the current temp" do
        expect(WeatherCmd.parse(user_input)).to eq("17.8C, moderate rain")
      end
    end

    context "Weather forecast" do
      let(:user_input) { ["in", "Tel-Aviv,", "IL", "2", "days", "from", "now"] }

      it "should return the weather forecast two days from now" do
        # TODO
      end
    end
  end
end
