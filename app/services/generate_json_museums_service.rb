class GenerateJsonMuseumsService
  require "json"

  def generate_json_museum(lng, lat)
    service_mapbox = CallGeocodingApiService.new
    result_api = service_mapbox.call_geocoding_api(lng, lat)

    json = JSON.parse(result_api)

    order_data_from_json(json)
  end

  private

  def order_data_from_json(json)
    hash_data = Hash.new()
    json['features'].each do |museum|
      name = museum['text']
      cp = find_postcode(museum)

      if hash_data.key?(cp)
        hash_data[cp] << name
      else
        hash_data[cp] = [name]
      end
    end

    return hash_data
  end

  def find_postcode(museum)
    cp = ""

    museum['context'].each do |x|
      if x['id'].include? "postcode"
        cp = x['text']
        break
      end
    end

    return cp
  end

end
