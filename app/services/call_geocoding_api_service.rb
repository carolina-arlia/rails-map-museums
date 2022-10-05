class CallGeocodingApiService
  attr_reader :lng, :lat

  require "open-uri"
  GEOCODING_URL = "https://api.mapbox.com/geocoding/v5/mapbox.places/"


  def initialize(lng, lat)
    @lng = lng
    @lat = lat
  end

  def call_geocoding_api
    proximity = "proximity=#{@lng},#{@lat}"
    access_token = "access_token=#{ENV['MAPBOX_API_KEY']}"
    query_string = "types=poi&limit=10&#{proximity}&#{access_token}"

    URI.parse("#{GEOCODING_URL}museum.json?#{query_string}").open.read
  end

end
