class CallGeocodingApiService
  require "open-uri"
  GEOCODING_URL = "https://api.mapbox.com/geocoding/v5/mapbox.places/"
  MAPBOX_API_KEY = 'MAPBOX_API_KEY'

  def call_geocoding_api(lng, lat)
    proximity = "proximity=#{lng},#{lat}"
    access_token = "access_token=#{ENV[MAPBOX_API_KEY]}"
    query_string = "types=poi&limit=10&#{proximity}&#{access_token}"

    URI.parse("#{GEOCODING_URL}museum.json?#{query_string}").open.read
  end

end
