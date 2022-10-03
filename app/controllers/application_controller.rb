class ApplicationController < ActionController::Base
  require "json"
  require "open-uri"
  GEOCODING_URL = "https://api.mapbox.com/geocoding/v5/mapbox.places/"
  LIMIT = 6
  PLACE_TYPE = "postcode"

  def generate_json
    # category = params[:category].singularize
    # parsed_response = JSON.parse(call_geocoding_api(category))
    # result = group_by_place_type(
    #   parsed_response['features'], PLACE_TYPE, category, LIMIT
    # )
    # render json: result


    lng = params[:lng]
    lat = params[:lat]

    json = call_geocoding_api(lng, lat)

    render json: get_data_from_json(json)

  end

  private

  def call_geocoding_api(lng, lat)
    proximity = "proximity=#{lng},#{lat}"
    access_token = "access_token=#{ENV['MAPBOX_API_KEY']}"

    query_string = "types=poi&limit=10&#{proximity}&#{access_token}"
    JSON.parse(URI.parse("#{GEOCODING_URL}museum.json?#{query_string}").open.read)
  end

  def get_data_from_json(json)
    hash_data = Hash.new()
    json['features'].each do |museum|
      name = museum['text']
      cp = museum['context'][0]['text']

      if hash_data.key?(cp)
        hash_data[cp] << name
      else
        hash_data[cp] = [name]
      end
    end

    return hash_data
  end

  def group_by_place_type(pois, place_type, category, limit)
    empty_hash = Hash.new {|hash, key| hash[key] = []}
    n = 0
    pois.each_with_object(empty_hash) do |poi, result|
      return result if n >= limit
      next unless in_category?(poi, category)

      postcode = find_place(poi, place_type)
      result[postcode] << poi["text"]
      n += 1
    end
  end

  def in_category?(poi, category)
    categories = poi['properties']['category'].split(', ')
    categories.include?(category)
  end

  def find_place(poi, place_type)
    poi['context'].find do |place|
      extract_place_type(place['id']) == place_type
    end['text']
  end

  def extract_place_type(place_id)
    place_id.split('.').first
  end

end
