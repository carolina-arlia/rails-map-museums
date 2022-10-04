class ApplicationController < ActionController::Base
  require "json"
  require "open-uri"
  GEOCODING_URL = "https://api.mapbox.com/geocoding/v5/mapbox.places/"

  def generate_json
    lng = params[:lng]
    lat = params[:lat]

    service_museums = GenerateJsonMuseums.new(lng, lat)

    json = JSON.parse(call_geocoding_api(lng, lat))

    render json: get_data_from_json(json)
  end

  private

  def call_geocoding_api(lng, lat)
    proximity = "proximity=#{lng},#{lat}"
    access_token = "access_token=#{ENV['MAPBOX_API_KEY']}"
    query_string = "types=poi&limit=10&#{proximity}&#{access_token}"

    URI.parse("#{GEOCODING_URL}museum.json?#{query_string}").open.read
  end

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
