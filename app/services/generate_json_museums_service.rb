class GenerateJsonMuseumsService
  require "json"
  attr_reader :lng, :lat

  # we receive all parameters in the initialization
  def initialize(lng, lat)
    @lng = lng
    @lat = lat
  end

  def generate_json_museum
    service_mapbox = CallGeocodingApiService.new(@lng, @lat)
    result_api = service_mapbox.call_geocoding_api

    json = JSON.parse(result_api)

    order_data_from_json(json)
  end

  private

  def order_data_from_json(json)
    hash_data = Hash.new()
    json['features'].each do |museum|
      name = museum['text']
      cp = ""

      museum['context'].each do |x|
        if x['id'].include? "postcode"
          cp = x['text']
          break
        end
      end

      if hash_data.key?(cp)
        hash_data[cp] << name
      else
        hash_data[cp] = [name]
      end
    end

    return hash_data
  end

end
