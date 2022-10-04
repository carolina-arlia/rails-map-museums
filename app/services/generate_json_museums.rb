class GenerateJsonMuseums

  def initialize(lng, lat)
    @lng = lng
    @lat = lat

    service = CallGeocodingApi.new(@lng, @lat)
  end

  private

  def get_data_from_json(json)
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
