class ApplicationController < ActionController::Base

  def generate_json
    lng = params[:lng]
    lat = params[:lat]

    service_museums = GenerateJsonMuseumsService.new(lng, lat)
    result_museums = service_museums.generate_json_museum

    render json: result_museums
  end

end
